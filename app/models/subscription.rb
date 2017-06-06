class Subscription < Plan

  api_response_mapper YV::API::Mapper::Subscription


  # Inherits all plan attributes
  attribute :auth
  attribute :user_id
  attribute :user_name
  attribute :user_avatar_url

  attribute :private
  attribute :completion_percentage
  attribute :token
  
  attribute :end_dt
  attribute :start_dt
  attribute :start_day
  attribute :subscribed_dt

  attribute :langugage_tag
  attribute :email_delivery
  attribute :email_delivery_version_id

  class << self

    def delete_path
      "#{api_path_prefix}/unsubscribe_user"
    end

    def destroy_id_param
      :id
    end

    def find(plan, opts = {})
      raise YV::AuthRequired unless opts[:auth]
      auth = opts[:auth]
      opts[:user_id] = opts[:auth].user_id
      opts[:cache_for] = 0
      found = super(plan, opts)
      found.auth = auth
      return found if found.valid?
      return nil if found.invalid? and found.errors.full_messages.include? "reading_plans.reading_plan.not_found"
      return found
    end

    def list_path
      "reading-plans/items"
    end

    def all(user,opts={})
      raise "Incorrect user argument" unless user.respond_to?(:id) and user.respond_to?(:auth)
      opts[:user_id]  = user.id
      opts[:auth]     = user.auth
      cache_time = request_for_user?(opts) ? 0 : YV::Caching.a_longer_time
      cache_for(opts[:cache_for] || cache_time, opts) # give precedence to manually set cache_for
      data, errs = get(list_path, opts)
      results = YV::API::Results.new(data,errs)
      if not_found?(errs)
        false
      else
        map_all(results)
      end
    end

    def completed(user, opts = {})
      raise "Incorrect user argument" unless user.respond_to?(:id) and user.respond_to?(:auth)
      opts[:user_id]  = user.id
      opts[:auth]     = user.auth
      cache_time = request_for_user?(opts) ? 0 : YV::Caching.a_longer_time
      cache_for(opts[:cache_for] || cache_time, opts) # give precedence to manually set cache_for
      data, errs = get(completed_path, opts)
      results = YV::API::Results.new(data,errs)
      if not_found?(errs)
        false
      else
        map_all(results)
      end
    end

    def completed_all_items(user, opts = {})
      raise "Incorrect user argument" unless user.respond_to?(:id) and user.respond_to?(:auth)
      opts[:auth]      = user.auth
      opts[:cache_for] = 0
      data, errs = get(completed_all_items_path, opts)
      YV::API::Results.new(data,errs)
    end

    def saved(user, opts = {})
      raise "Incorrect user argument" unless user.respond_to?(:id) and user.respond_to?(:auth)
      opts[:user_id]  = user.id
      opts[:auth]     = user.auth
      cache_time = request_for_user?(opts) ? 0 : YV::Caching.a_longer_time
      cache_for(opts[:cache_for] || cache_time, opts) # give precedence to manually set cache_for
      data, errs = get(saved_path, opts)
      results = YV::API::Results.new(data,errs)
      if not_found?(errs)
        false
      else
        map_all(results)
      end
    end

    def allSavedIds(user, opts = {})
      raise "Incorrect user argument" unless user.respond_to?(:id) and user.respond_to?(:auth)
      opts[:user_id]  = user.id
      opts[:auth]     = user.auth
      cache_time = request_for_user?(opts) ? 0 : YV::Caching.a_longer_time
      cache_for(opts[:cache_for] || cache_time, opts) # give precedence to manually set cache_for
      data, errs = get(allSavedIds_path, opts)
      YV::API::Results.new(data,errs)
    end

    def saveForLater(plan, opts={})
      raise YV::AuthRequired unless opts[:auth]
      opts.merge!(
          user_id:  opts[:auth].user_id,
          id:       id_from_param(plan)
      )
      data, errs = post( saveForLater_path, opts)
      return YV::API::Results.new(data,errs)
    end

    def removeSaved(plan, opts={})
      raise YV::AuthRequired unless opts[:auth]
      opts.merge!(
          user_id:  opts[:auth].user_id,
          id:       id_from_param(plan)
      )
      data, errs = post( removedSaved_path, opts)
      return YV::API::Results.new(data,errs)
    end

    def subscribe(plan, opts={})
      raise YV::AuthRequired unless opts[:auth]
      opts.merge!(
        user_id:  opts[:auth].user_id,
        id:       id_from_param(plan)
      )

      data, errs = post( subscribe_path, opts)
      return map_subscribe(YV::API::Results.new(data,errs))
    end

    def subscribe_path
      "reading-plans/subscribe_user"
    end

    def saveForLater_path
      "reading-plans/add_to_queue"
    end

    def removedSaved_path
      "reading-plans/remove_from_queue"
    end

    def allSavedIds_path
      "reading-plans/all_queue_items"
    end

    def map_subscribe(results)
      @api_response_mapper.map_subscribe(results)
    end

    def unsubscribe(plan,user,opts={})
      raise YV::AuthRequired unless opts[:auth]

      opts[:id]  = id_from_param(plan)
      data, errs = post( unsubscribe_path, opts)
      YV::API::Results.new(data,errs)
    end

    def unsubscribe_path
      "reading-plans/unsubscribe_user"
    end    


    private

    def id_from_param(param)
      case param
        when Plan, Subscription
          param.id.to_i
        when /^(\d+)[-](.+)/    # format 1234-plan-slug
          param.match(/^(\d+)[-](.+)/)[1].to_i
        when Fixnum, /\A[\d]+\z/
          param.to_i
      end
    end

  end
  # END Class method definitions --------------------------------------------------------------------------------



  def initialize( data={} , opts = {})
    super(data)
    @user = opts[:user] || nil # keep @user around to avoid further api calls
  end

  def completed?
    @completed || false
  end

  def public?
    not private?
  end

  def private?
    private
  end

  def make_public
    update_subscription(private: false)
  end

  def make_private
    update_subscription(private: true)
  end

  def delivered_by_email?
    not email_delivery.nil?
  end

  # Human readable time range for email_delivery API value
  def email_delivery_time_range
    return nil if email_delivery.nil?
    case email_delivery[0..2].to_i
      when 4..7     then "morning"
      when 12..15   then "afternoon"
      when 16..19   then "evening"
      else nil
    end
  end

  def disable_email_delivery
    update_subscription(email_delivery: nil)
  end

  def enable_email_delivery(opts={})
    #TODO: make required opts params and/or handle nils, this is too opaque
    params = {}
    #TODO replace this with Version object creation when lazyloading is implemented
    implicit_version = Version.id_from_param opts[:default_version]
    explicit_version = Version.id_from_param opts[:picked_version]

    params[:email_delivery_version_id] = explicit_version || version_id || implicit_version
    params[:email_delivery] = delivery_time(opts[:time])

    update_subscription(params)
  end

  def catch_up
    modify_subscription("reading-plans/reset_subscription","catch_up")
  end
 
  def restart
    modify_subscription("reading-plans/restart_subscription","restart")
  end

  def modify_subscription(path,action)
    raise "Auth required." unless auth
    data, errs = self.class.post(path, {auth: auth, id: id})
    results = YV::API::Results.new(data,errs)
      raise_errors( results.errors, "subscription##{action}") unless results.valid?
    
    return self.class.map(results, self, :update)
  end

  def add_accountability_user(user)
    update_accountability(user, action: "add")
  end

  def remove_accountability_user(user)
    update_accountability(user, action: "delete")
  end

  def accountability_partners
    @partners ||= update_accountability_partners  #cached so we allow iteration on this array
  end

  def remove_all_accountability
    accountability_partners.each{|p| remove_accountability_user(p.id)}
  end

  def delete
    unsubscribe
  end

  def unsubscribe
    raise "Auth required." unless auth
    destroy
  end


  # Auth required

  def set_ref_completion(day, ref, devo, completed)
    raise "Auth required" unless auth

    opts = {auth: auth, id: id, day: day}


    # Get the list of completed references to send back to the API
    # (all others will be marked as not-complete)
    completed_refs = ReferenceList.new
    reading(day).api_references.each do |r_mash|
      completed_refs << Reference.new(r_mash.reference, version: nil) if r_mash.completed?
    end

    if !ref.nil?
      #using no version ref to use native #delete and #uniq methods below
      no_version_ref = Reference.new(ref, version: nil)

      #adjust the ref_list based on the new completion state for the ref
      completed ? completed_refs << no_version_ref : completed_refs.delete(no_version_ref)
    end

    completed_refs.uniq!
    opts[:references] = completed_refs.to_usfm
    opts[:devotional] = devo
    
    data, errs = self.class.post("#{api_path_prefix}/update_completion", opts)
    results = YV::API::Results.new(data,errs)
    unless results.valid?
      raise_errors( results.errors, "subscription#set_ref_completion")
    end

    @completed = true and return if (data.id.present? && data.total_days.blank?)

    @readings.delete(day.to_s.to_sym)
    return true
  end

  def user=(u)
    @user = u
  end

  def user
    @user ||= User.find(auth ? auth : user_id.to_i)
  end

  def progress
    completion_percentage
  end

  def day_statuses
    data, errs = self.class.get("#{api_path_prefix}/calendar", {auth: auth, id: id, user_id: user_id, timeout: 15000})
    results = YV::API::Results.new(data,errs)
      raise_errors( results.errors, "subscription#day_statuses") unless results.valid?

    return data
  end

  def last_completed_date
    #Returnes nil if no days have been completed
    statuses = day_statuses
    index = statuses.rindex{|day_mash| day_mash.completed}
    return nil if index.nil?

    Date.parse(statuses[index].date)
  end

  def last_completed_day
    #Returnes nil if no days have been completed
    statuses = day_statuses
    index = statuses.rindex{|day_mash| day_mash.completed}
    return nil if index.nil?

    statuses[index].day.to_i
  end

  def start
    Date.parse(@attributes.start_dt)
  end

  def end
    Date.parse(@attributes.end_dt)
  end

  def reading_date(day)
    (start + day) - 1
  end

  def days
    @attributes.total_days
  end

  def total_days
    days.to_i
  end

  def current_day
    [((DateTime.now.utc + user.utc_date_offset) - start).floor + 1, total_days].min
  end

  def current_reading
    reading(current_day)
  end

  def reading(day, opts = {})
    # Important: don't allow caching for this authed responses since completion needs to change
    super(day, opts.merge!({cache_for: 0, auth: auth, user_id: user_id})) # TODO: can we use auth.user_id instead of getting it from @user (that means we don't have to set @user on subscription)
  end

  def day(day, opts = {})
    reading(day, opts)
  end



  private


  def update_subscription(opts = {})
    raise "Auth required." unless self.auth || opts[:auth]
    
    opts[:id]      = id
    opts[:auth]    ||= self.auth
    opts[:private] = self.private if opts[:private].nil?

    # email_delivery  00:00:00 FORMAT for time to deliver email
    # best if random to spread load (re: convo with CV)
    if opts[:email_delivery].blank?
      opts[:email_delivery] = opts[:email_delivery_version_id] = nil
    else
      opts[:email_delivery] ||= email_delivery
      opts[:email_delivery_version_id] ||= email_delivery_version_id
    end

    data, errs = self.class.post("#{api_path_prefix}/update_subscribe_user", opts)
    return self.class.map(YV::API::Results.new(data,errs), self, :update)
  end

  # def update_accountability_partners
  #   @partners = Subscriptions::Partner.all(
  #     id: id,
  #     page: 1,
  #     auth: auth,
  #     user_id: user_id
  #   )
  # end


  # def update_accountability(user, params={})
  #   opts = {auth: auth, id: id, user_id: user.id}

  #   results = case params[:action]
  #     when "add"    then Subscriptions::Partner.add(opts)
  #     when "delete" then Subscriptions::Partner.delete(opts)
  #   end

  #   @partners = nil if results.valid? # flush cached @partners now that we've made changes

  #   return results
  # end

  def delivery_time(time_range)
    hours = case time_range
    when "morning"
      (4..6)        #4-6:59:59
    when "afternoon"
      (12..14)      #12-2:59:59
    when "evening"
      (16..18)      #4-6:59:59
    else
      (4..6)        #4-6:59:59 Morning seems preferred default #delivery_time(["morning","afternoon","evening"].sample)
    end

    "%02d:%02d:%02d" % [hours.to_a.sample, (0..59).to_a.sample, (0..59).to_a.sample]
  end
end
