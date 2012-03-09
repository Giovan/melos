class UsersController < ApplicationController
  before_filter :force_login, only: [:share, :bookmarks, :profile, :update_profile, :picture, :update_picture, :password, :update_password, :connections, :devices, :destroy_device, :update_email_form, :update_email, :confirm_update_email]
  before_filter :force_notification_token_or_login, only: [:notifications, :update_notifications]
  before_filter :find_user, except: [:new, :create, :confirm_email, :confirm, :new_facebook, :create_facebook, :notifications, :update_notifications]
  before_filter :set_redirect, only: :new
  
  # User signup flow:
  #
  #  +>  /sign-up (users#new)  <-err--------+
  #  |     |             |                  |
  #  |   form submit   facebook btn         |
  # err    |                 \              |
  #  |  success?           facebook auth (/auth/facebook/sign-up)
  #  |   /   \                  \           |
  #  +-no     yes              success?     |
  #            |                /    \      |
  #      /confirm-email      yes     no ----+
  #          (...)            |
  #       clicks link      /sign-up/facebook   <----+
  #           |               |                     |
  #       /confirm        fill out form & submit    |
  #           |                     |               |
  #       valid code?           success?           err
  #         /     \              /    \             |
  #       yes     no           yes     no ----------+
  #        |       \            |
  #     redirect   /confirm     |
  #        |       (with error) |
  #        +--------------------+
  #        |
  #   /sign-up/success (or sign_up_redirect)

  def new
    @user = User.new
    # Set the blurb
    if params[:source]
      @blurb = t("registration.#{params[:source]} blurb")
    elsif params[:redirect] && params[:redirect].match(/reading\-plans/)
      @blurb = t("registration.plan blurb")
    end

    # Try reading plan?
    cookies[:sign_up_redirect] = params[:redirect]
    render action: "new", layout: "application"
  end

  def create
    @user = User.new(params[:user])
    # Try authing them first - poor man's login screen
    begin
      if test_user = User.authenticate(params[:user][:username], params[:user][:password])
        puts "hey i am actually an existing user"
        new_place = cookies[:sign_up_redirect] || :back
        puts "new place is #{new_place}"
        sign_in test_user, params[:user][:password]
        redirect_to new_place
      end
    rescue
      if @user.save
        # save username and password so we can sign them back in
        cookies.signed[:f] = params[:user][:username]
        cookies.signed[:g] = params[:user][:password]
        redirect_to confirm_email_path
      else
        render action: "new"
      end
    end
  end

  def confirm_email
    render layout: "application"
  end

  def confirm
    response = YvApi.post("users/confirm", hash: params[:hash]) do |errors|
      new_errors = errors.map { |e| e["error"] }
      self.errors[:base] << new_errors
      return false
    end
    if response
      redirect_to cookies[:sign_up_redirect] ||= sign_up_success_path(show: "facebook")
    end
  end

  def new_facebook
    facebook_auth = JSON.parse cookies.signed[:facebook_auth]
    @user = User.new
    @user.email = facebook_auth["info"]["email"]
    @user.verified = true
    render action: "new_facebook", layout: "application"
  end

  def create_facebook
    facebook_auth = JSON.parse cookies.signed[:facebook_auth]
    @user = User.new(params[:user])
    @user.email = facebook_auth["info"]["email"]
    @user.verified = true
    if @user.save
      # Get the real thing
      user = User.authenticate(params[:user][:username], params[:user][:password])
      cookies.permanent.signed[:a] = user.id

      cookies.permanent.signed[:b] = user.username
      cookies.permanent.signed[:c] = params[:user][:password]
      cookies.permanent[:avatar] = user.user_avatar_url["px_24x24"]

      # Create facebook connection
      #
      info = facebook_auth.symbolize_keys
      info[:auth] = Hashie::Mash.new(user_id: user.id, username: user.username, password: params[:user][:password])
      connection = FacebookConnection.new(info)
      result = connection.save

      redirect_to cookies[:sign_up_redirect] ||= sign_up_success_path(show: "facebook")
    else
      render action: "new_facebook", layout: "application"
    end
  end

  def sign_up_success
    @show = (params[:show] || "facebook").to_s
    @users = @user.connections[@show].find_friends if @user.connections[@show]
    render action: "sign_up_success", layout: "application"
  end

  def show
    @selected = :recent_activity
  end

  def notes
    @nav = :notes if @me
    @selected = :notes
    @notes = @user.notes(page: params[:page])
  end

  def likes
    @likes = @user.likes(page: params[:page])
    @selected = :likes
    @empty_message = t('no likes found', username: @user.name || @user.username )
  end

  def bookmarks
    @selected = :bookmarks
    @nav = :bookmarks if @me
    if params[:label]
      @bookmarks = Bookmark.for_label(params[:label], {page: @page, :user_id => @user.id})
    else
      @bookmarks = @user.bookmarks(page: params[:page])
    end
    @labels = Bookmark.labels_for_user(@user.id, page: @labels_page) if Bookmark.labels_for_user(@user.id)
    render "bookmarks/index", layout: "application" if @me
  end

  def badges
    @selected = :badges
    @badges = @user.badges
  end

  def share
    puts "in controller action"
    puts request.referer
    puts params[:share]
    puts @user
    if @user.share(params[:share])
      redirect_to :back, notice: t('share success')
    else
      redirect_to :back, error: t('share error')
    end
  end

  #
  # Profile actions
  #

  def profile
    @selected = :profile
  end

  def update_profile
    result = @user.update(params[:user]) ? flash.now[:notice]=(t('users.profile.updated')) : flash.now[:error]=(t('users.profile.error'))
    render action: "profile"
  end

  def picture
    @selected = :picture
  end

  def update_picture
    result = @user.update_picture(params[:user][:image])
    result ? flash.now[:notice] = t('users.profile.updated picture') : flash.now[:error] = @user.errors
    render action: "picture"
  end

  def notifications
    @notification_settings = NotificationSettings.find(params[:token] ? {token: params[:token]} : {auth: current_auth})
    @user = @notification_settings.user
    @me = true
    @selected = :notifications
  end

  def update_notifications
    @notification_settings = NotificationSettings.find(params[:token] ? {token: params[:token]} : {auth: current_auth})
    @user = @notification_settings.user
    @me = true
    result = @notification_settings.update(params[:notification_settings])
    result ? flash.now[:notice] = t('users.profile.updated notifications') : flash.now[:error] = t('users.profile.notification errors')
    render action: "notifications"
  end

  def password
    @selected = :password
  end

  def update_password
    if params[:user][:old_password] == current_auth.password
      result = @user.update(params[:user].except(:old_password)) ? flash.now[:notice]=(t('users.password.updated')) : flash.now[:error]=(t('users.password.error'))
      cookies.signed.permanent[:c] = params[:user][:password] if result
    else
      flash.now[:error]= t('users.password.old was invalid')
    end
    render action: "password"
  end

  def resend_confirmation
    if params[:email]
      if User.resend_confirmation(params[:email])
        return render action: "resend_confirmation_success", layout: "application"
      else
        flash.now[:error]=(t('users.resend error'))
      end
    end
    render action: "resend_confirmation", layout: "application"
  end

  def connections
    params[:page] ||= 1
    @selected = :connections
    @show = params[:show] ||= "twitter"
    @empty_message = t('users.no connection friends', connection: t(@show))
    if @user.connections[@show]
      @users = @user.connections[@show].find_friends(page: params[:page])
    end
  end

  def devices
    @devices = @user.devices
    @selected = :devices
  end

  def destroy_device
    @device = Device.find(params[:id], auth: current_auth)
    if @device.destroy
      flash[:notice] = "Device removed."
      redirect_to devices_path
    else
      flash.now[:error] = "Could not delete device."
      render action: "devices"
    end
  end

  def update_email_form
    render "update_email"

  end

  def update_email
    response = @user.update_email(params[:user][:email])
    if response
      render "update_email_success"
    else
      render "update_email"
    end
  end

  def confirm_update_email
    response = @user.confirm_update_email(params[:token])
  end

  def forgot_password_form
    render "forgot_password", layout: "application"
  end

  def forgot_password
    result = User.forgot_password(params[:email])
    if result
      sign_out
      render "forgot_password_success", layout: "application"
    else
      flash.now[:error] = t('users.invalid email forgot')
      render "forgot_password", layout: "application"
    end
  end

  def following
    @users = @user.following({page: params[:page] ||= 1})
    @selected = :friends
    @really_selected = :following
    if @me
      @empty_message = t('no following found self', link: connections_path)
    else
      @empty_message = t('no following found other', username: @user.username)
    end
    render action: "friends"
  end

  def followers
    @users = @user.followers({page: params[:page] ||= 1})
    @selected = :friends
    @really_selected = :followers
    if @me
      @empty_message = t('no followers found self', link: connections_path)
    else
      @empty_message = t('no followers found other', username: @user.username)
    end
    render action: "friends"
  end

  # Friends, etc
  def follow
    if @user.follow
      redirect_to(:back, notice: t('you are now following', username: @user.username))
    else
      redirect_to(:back, error: t('error following user'))
    end
  end

  def unfollow
    if @user.unfollow
      redirect_to(:back, notice: t('you are no longer following', username: @user.username)) 
    else
      redirect_to(:back, error: t('error unfollowing user'))
    end

  end
  
  def privacy
    I18n.locale = :en if [:fr, :ja, :pl, :zh_CN, :zh_TW].find{|loc| loc == I18n.locale}
    render action: "privacy", layout: "application"
  end
  
  def terms
    I18n.locale = :en if [:fr, :ja, :pl, :zh_CN, :zh_TW].find{|loc| loc == I18n.locale}
    render action: "terms", layout: "application"
  end
  
private  
  def find_user
    user_id = params[:user_id] || params[:id]
    if user_id
      @user = User.find(user_id, auth: current_auth)
      @me = (current_auth && @user.id.to_i == current_auth.user_id.to_i)
    else
      @user = current_user
      @me = true
    end
  end
end
