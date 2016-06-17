class FriendshipsController < ApplicationController

  respond_to :html, :json

  before_filter :force_login
  prepend_before_filter :mobile_redirect, only: [:requests], :unless => lambda{ |controller| controller.request.format.json? }

  def requests
    @friendships = Friendships.incoming(page: @page, auth: current_auth)
    respond_with(@friendships)
  end

  # Accept a friendship
  def create
    @friendship = Friendships.accept(request_opts(params[:user_id]))

    # if missing first_name & last_name, redirect to profile with notice message
    if current_user.first_name.blank? && current_user.last_name.blank?
      return redirect_to(edit_user_path(id: current_user.username), notice: t('users.profile.complete_first_last')) 
    end

    respond_to do |format|
      format.json { render json: { notice: select_notice(@friendship,:create) } }
      format.any { redirect_to(:back, notice: select_notice(@friendship, :create)) }
    end


    # eventually support json/ajax submission for javascript menus, etc.
    #respond_with(@friendship)
  end

  def offer
    @friendship = Friendships.offer(request_opts(params[:user_id]))
    respond_to do |format|
      format.json { render json: { notice: select_notice(@friendship,:offer) } }
      format.any { redirect_to(:back, notice: select_notice(@friendship,:offer)) }
    end
  end

  # Decline
  # This is a bit hackish with regards to Rails REST best practices
  # DELETE /friendships/:id
  # params[:id] is not the id(pk) of a server side Friendship
  # params[:id] is being used as a user_id in this particular scenario
  def destroy
    @friendship = Friendships.decline(request_opts(params[:id]))
    respond_to do |format|
      format.json { render json: { notice: select_notice(@friendship,:destroy) } }
      format.any { redirect_to(:back, notice: select_notice(@friendship,:destroy)) }
    end
  end

  private

  def request_opts(id)
    {user_id: id.to_i, auth: current_auth}
  end

  def select_notice( friendship , api_method )
    raise "Invalid i18n key" unless [:create,:offer,:destroy].include? api_method
    friendship.valid? ? t("friendships.#{api_method.to_s} success") : t("friendships.#{api_method.to_s} failure")
  end

end