class SessionsController < ApplicationController
  
  before_filter :set_redirect, except: [:destroy]

  def new
  end

  def create
    begin
      @user = User.authenticate(params[:username], params[:password])
    rescue UnverifiedAccountError
      params[:email] = params[:username] if params[:username].include? "@"
      return render "unverified"
    end

    if @user.valid?
      sign_in(@user, params[:password])
      I18n.locale = @user.language_tag.gsub('_', '-') unless @user.language_tag.nil?
      location = redirect_path
      location ||= (I18n.locale == I18n.default_locale) ? "/#{I18n.default_locale}#{moments_path}" : moments_path
      clear_redirect
      redirect_to(location) and return
    else
      render "new" and return
    end
  end

  def destroy
    sign_out
    redirect_to (params[:redirect] || bible_path)
  end
end
