class NotificationsController < ApplicationController

  layout 'settings'

  respond_to :html, :json

  before_filter :force_login, only: [:show]
  before_filter :force_notification_token_or_login, only: [:edit, :update]

  def show
    @user = get_user
    @notifications = get_notifications
    respond_with @notifications do |format|
      format.html { render :layout => 'users' }
    end
  end

  def edit
    @current_user = get_user
    @results = NotificationSettings.find(params[:token].present? ? {token: params[:token]} : {auth: current_auth})
    @settings = @results.data
    self.sidebar_presenter = Presenter::Sidebar::User.new(@user,params,self)
  end

  def update
    @settings = NotificationSettings.find(params[:token] ? {token: params[:token]} : {auth: current_auth})
    @results = @settings.update(params[:settings] || {})
    if @results.valid?
       flash[:notice] = t('users.profile.updated notifications')
       redirect_to(edit_notifications_path(token: params[:token]))
    else
      @user = get_user
      flash[:error] = t('users.profile.notification errors')
    end
  end

  def destroy
    # This method is for clearing (marking as read) notifications
    # Rather than shoehorning this into update (messy), or separating controllers (probably the best option, but most complex)
    Notification.read!(auth: current_auth)
    # No error checking client side, so pull a Nike and Just Do It
    render json: true
  end

  private

  def get_user
    if current_auth
      current_user
    elsif settings = NotificationSettings.find({token: params[:token]})
      User.find(settings.user_id)
    else
      force_login
    end
  end


  def get_notifications
    notifications = current_auth.present? ? Notification.all(auth: current_auth) : []
    # Filter on params[:length] if necessary
    notifications = notifications[0...params[:length].to_i] if params[:length]
    notifications
  end

end