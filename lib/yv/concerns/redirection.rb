module YV
  module Concerns
    module Redirection
    
      def self.included(base)
        base.helper_method :redirect_path, :clear_redirect,:follow_redirect
      end

    private

      # set redirect for (to) argument
      # otherwise set redirect location to a redirect param if available
      def set_redirect(to = nil)
        clear_redirect if cookies[:auth_redirect] == "" #EVENTUALLY: understand why this cookie is "" instaed of nil/dead, to avoid this workaround
        cookies[:auth_redirect] = to if to.present?
        cookies[:auth_redirect] = params[:redirect] if params[:redirect].present?
        cookies[:auth_redirect]
      end

      def redirect_path
        cookies[:auth_redirect]
      end

      def clear_redirect
        cookies[:auth_redirect] = nil
      end

      def next_redirect?( to )
        redirect_path == to
      end


      def follow_redirect(opts = {})
        cookie_path = cookies[:auth_redirect].to_s == '' ? nil : cookies[:auth_redirect] #EVENTUALLY: understand why this cookie is "" instaed of nil/dead, to avoid this workaround
        clear_redirect
        path = cookie_path || opts[:alt_path] || bible_path
        return redirect_to path, notice: opts[:notice] if opts[:notice]
        return redirect_to path, error: opts[:error] if opts[:error]
        return redirect_to path
      end

      def external_request?
        return true  if request.referer.blank?
        return false if request.host == request.referer.split('/')[2].split(':')[0]
        return true
      end

      def mobile_redirect
        
        # todo: model
        # for now use a dictionary here

        dict = Hashie::Mash.new(
          {
            moments: 
              {
               index:     "moments", 
               show:      "moments/#{params[:id]}"
              },
            highlights:
              {
               show:      "moments/#{params[:id]}"
              },
            bookmarks:
              {
               show:      "moments/#{params[:id]}"
              },
            notes:
              {
               show:      "moments/#{params[:id]}"
              },
            badges:
              {
               show:      "moments/#{params[:id]}"
              },
            videos:
              {
                index:    "videos?",
                show:     "videos?id=#{params[:id].to_i}",
                series:   "videos?id=#{params[:id].to_i}"
              },
            plans:
              {
                index:    "reading_plans?category=#{params[:category]}",
                show:     "reading_plan_detail?id=#{params[:id].match /(\d+)/ if params[:id].present?}",
                sample:   "reading_plan_day?id=#{params[:id].match /(\d+)/ if params[:id].present?}&day=#{params[:day] if params[:day].present?}"
              },
            languages:
              {
                show:     "language?id=#{params[:id]}"
              },
            versions:
              {
                show:     "version?id=#{params[:id].to_s.split("-").first}"
              },
            subscriptions:
              {
                # index:    "my_reading_plans",
                show:     "reading_plan_day?id=#{params[:id].match /(\d+)/ if params[:id].present?}&day=#{params[:day] if params[:day].present?}",
              },
            users:
              {
                show:       "my_profile",
                notes:      "my_notes",
                bookmarks:  "bookmarks",
                badges:     "my_profile"
              },
            references:
              {
                # show:     "bible?reference=#{params[:reference]}&version=#{params[:version]}"
              },
            friendships:
              {
                requests:   "friends"
              },
            connections:
              {
                index:      "connections"
              },
            redirects:
              {
                bookmarks:    "bookmarks",
                profile:      "my_profile",
                friends:      "friends",
                notes:        "notes",
                badges:       "badges",
                highlights:   "highlights",
                connections:  "connections"
              }
          }
        )

        case request.env["X_MOBILE_DEVICE"]
        when /iphone|iPhone|ipad|iPad|ipod|iPod/
          @user_agent = "ios"
        when /android|Android/
          @user_agent = "android"
        end
        @native_path = dict[controller_name][action_name] rescue nil
        @native_url = "youversion://#{@native_path}" if @native_path.present?
        if current_auth.nil?
          session[:native_url] = @native_url
          session[:user_agent] = @user_agent
        end

        # specific intent handling for Android Chrome
        unless params.has_key?(:ret)
          browser = Browser.new(request.env["HTTP_USER_AGENT"])
          if browser.platform.android? and browser.chrome? and not @native_path.nil?
            android_scheme = "youversion"
            android_package = "com.sirma.mobile.bible.android"
            encoded_browser_fallback = ERB::Util.url_encode("#{request.base_url}#{request.path}?ret=1")
            # intent_url = "intent://#{@native_path}#Intent;scheme=#{android_scheme};package=#{android_package};S.browser_fallback_url=#{encoded_browser_fallback};end;"
            intent_url = "intent://#{encoded_browser_fallback}#Intent;scheme=#{android_scheme};package=#{android_package};S.browser_fallback_url=#{encoded_browser_fallback};end;"
            redirect_to intent_url, :status => 307 and return
          end
        end
      end

    end
  end
end