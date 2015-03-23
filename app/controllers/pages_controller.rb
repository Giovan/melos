class PagesController < ApplicationController

  before_filter :force_login, only: [:donate]

  def about;        end
  def press;        end
  def mobile;       end
  def status;       end
  def api_timeout;  end
  def generic_error;end

  def feed;end
  def notifications;end
  def requests;end
  def intro;end

  # /app url - redirects to an store for mobile device if found
  # tracks requests to /app to GA custom event.
  def app
    tracker = Gabba::Gabba.new(@site.ga_code, @site.ga_domain)
    tracker.identify_user(cookies[:__utma], cookies[:__utmz])
    tracker.event("App Download", "#{request.host_with_port}#{request.fullpath}")
    return redirect_store! unless request.env["X_MOBILE_DEVICE"].nil?
  end

  def privacy
    @locale = :en unless i18n_terms_whitelist.include? I18n.locale
  end

  def terms
    @locale = :en unless i18n_terms_whitelist.include? I18n.locale
  end

  def routing_error
    page = bdc_user? ? 'pages/bdc_home' : 'pages/error_404'
    render page, status: 404
  end

  def error_404
    render "pages/error_404", status: 404 and return
  end

  def i18n_terms_whitelist
    # the following localizations have the legal terms reviewed in a way that is
    # legally appropriate to show in a localized state
    [ :da, :en, :ja, :lv, :sv, :vi, :nl, :"pt", :"no", :"zh-CN",
      :"zh-TW", :ms, :ru, :ro, :"es-ES", :uk, :ko ]
  end

  def donate
    @user = current_user
    ts_auth = {
      :email => @user.email,
      :first_name => @user.first_name,
      :id => @user.id.to_s,
      :language_tag => @user.language_tag,
      :last_name => @user.last_name,
      :source => 'youversion'
    }

    @ts_signature = Licenses::Request.sign( ts_auth , ENV["TREADSTONE_SECRET"] ) unless ENV["TREADSTONE_SECRET"].nil?
  end

end
