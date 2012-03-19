class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  helper_method :follow_redirect, :redirect_path, :clear_redirect, :recent_versions, :set_cookie, :force_login, :find_user, :current_auth, :current_user, :current_date, :last_read, :set_last_read, :current_version, :alt_version, :set_current_version, :bible_path, :current_avatar, :sign_in, :sign_out
  before_filter :set_page
  before_filter :set_locale
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :generic_error
    rescue_from APIError, with: :api_error
    rescue_from AuthError, with: :auth_error
    rescue_from APITimeoutError, with: :timeout_error
  end

  def set_page
    @page = (params[:page] || 1).to_i
    @labels_page = (params[:labels_page] || 1).to_i
  end

  # Set locale
  def set_locale
    # params[:locale] ||= :en
    # 
    # I18n.locale = params[:locale]
    #TEMPORARY FOR PREVIEWL #TODO: remove for go-live
    # if params[:locale]
    #   cookies.permanent[:locale] = :en
    #   return redirect_to l10n_path 
    # end
    
    if params[:locale].nil?
      visitor_locale = cookies[:locale].blank? ? I18n.default_locale : cookies[:locale].to_sym
      cookies.permanent[:locale] = visitor_locale
      return redirect_to params.merge!(locale: visitor_locale) unless visitor_locale == :en
    else
      visitor_locale = I18n.available_locales.include?(params[:locale].to_sym) ? params[:locale].to_sym : :en
      cookies.permanent[:locale] = visitor_locale
      return redirect_to params.merge!(locale: "") if visitor_locale == :en
    end
    I18n.locale = visitor_locale
  end

  # Manually throw a 404
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  private
  def sign_in(user, password = nil)
    cookies.permanent.signed[:a] = user.id
    cookies.permanent.signed[:b] = user.username
    cookies.permanent.signed[:c] = password || params[:password]
    cookies.permanent[:avatar] = user.user_avatar_url["px_24x24"]
  end
  def sign_out
    cookies.permanent.signed[:a] = nil
    cookies.permanent.signed[:b] = nil
    cookies.permanent.signed[:c] = nil
    cookies.permanent[:avatar] = nil
  end
  def auth_error
    sign_out
    redirect_to(sign_in_path, flash: {error: t('auth error')})
  end
  def timeout_error(ex)
    @error = ex
    render "pages/api_timeout", layout: 'application', :status => 408
  end
  def api_error(ex)
    @error = ex
    render "pages/generic_error", layout: 'application', :status => 502
  end
  def generic_error(ex)
    @error = ex
    render "pages/generic_error", layout: 'application', :status => 500
  end
  def force_login(opts = {})
    if current_auth.nil?
      opts[:redirect] = request.path
      redirect_to sign_up_path(opts) and return 
      #EVENTUALLY: handle getting the :source string based on the referrer dynamically in the sign-in controller
    end
    @user = current_user
  end
  def force_notification_token_or_login
    if params[:token]
      redirect_to sign_out_path(redirect: notifications_path(token: params[:token])) and return if current_user && current_user.notifications_token != params[:token]
    else
      force_login
    end
  end
  def set_redirect
    cookies[:auth_redirect] = nil if cookies[:auth_redirect] == "" #EVENTUALLY: understand why this cookie is "" instaed of nil/dead, to avoid this workaround
    cookies[:auth_redirect] = params[:redirect] if params[:redirect]
    cookies[:auth_redirect] ||= URI(request.referer).path if request.referer
  end
  def redirect_path
    cookies[:auth_redirect]
  end
  def clear_redirect
    cookies[:auth_redirect]= nil
  end
  def follow_redirect(opts = {})
    path = cookies[:auth_redirect] || opts[:alt_path] || bible_path
    clear_redirect
    return redirect_to path
  end
  def last_read
    Reference.new(cookies[:last_read]) if cookies[:last_read]
  end
  def set_last_read(ref)
    cookies.permanent[:last_read] = ref.osis
  end
  def current_auth
    @current_auth ||= Hashie::Mash.new( {'user_id' => cookies.signed[:a], 'username' => cookies.signed[:b], 'password' => cookies.signed[:c]} ) if cookies.signed[:a]  
  end
  def external_request?
    return true if request.referrer.nil?
    
    return false if request.host == request.referrer.split('/')[2].split(':')[0]
    
    return true
  end
  def recent_versions
    return @recent_versions unless @recent_versions.nil?
    
    return [] if cookies[:recent_versions].to_s == ""
    
    return @recent_versions = cookies[:recent_versions].split('/').map{|osis| Version.find(osis)}
  end
  def current_user
    @current_user ||= User.find(current_auth) if current_auth
  end
  def current_username
    User.find(cookies.signed[:a]).username if cookies.signed[:a]
    #TODO: fix this, it's borked
  end
  def current_avatar
    cookies[:avatar]
  end
  def current_date
    #PERF: could cache but needs benchmarking if faster than checks to correctly invalidate
    current_user ? (DateTime.now.utc + current_user.utc_date_offset).to_date : Date.today
  end
  def current_version
    cookies[:version] || Version.default_for(params[:locale] ? params[:locale].to_s : "en")
  end
  def alt_version(ref)
    raise BadSecondaryVersionError if cookies[:alt_version] && !Version.find(cookies[:alt_version]).contains?(ref)
    return cookies[:alt_version] if cookies[:alt_version]
    
    recent = recent_versions.find{|v| v.osis != current_version && v.contains?(ref)}
    return cookies[:alt_version] = recent.osis if recent
    
    return cookies[:alt_version] = Version.sample_for((params[:locale] ? params[:locale].to_s : "en"), except: current_version, has_ref: ref)
  end
  def set_current_version(ver)
    cookies.permanent[:version] = ver.osis
  end
end
