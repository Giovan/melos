class YvApi
  include HTTParty
  format :json
  headers 'Referer' => "http://" + Cfg.api_referer
  default_timeout Cfg.api_default_timeout.to_i

  class << YvApi
    alias_method :httparty_get, :get
    alias_method :httparty_post, :post
  end

  def self.get(path, opts={}, &block)
    auth_from_opts!(opts)
    timeout = opts.delete(:timeout)
    resource_url = get_resource_url!(path, opts)
    opts = clean_up_opts(opts)
    Rails.logger.apc "** YvApi.get: Calling #{resource_url} with query:", :info
    Rails.logger.apc opts, :info

    # If we should cache, try pulling from cache first
    if cache_length = opts[:cache_for]
      cache_key = [path, opts.except(:cache_for).sort_by{|k,v| k.to_s}].flatten.join("_")
      Rails.logger.apc "*** cache fetch for key: #{cache_key}", :debug
      get_start = Time.now.to_f
      response = Rails.cache.fetch cache_key, expires_in: cache_length do
        Rails.logger.apc "*** cache miss for key: #{cache_key}", :debug
        # No cache hit; ask the API
        begin
          response = httparty_get(resource_url, timeout: timeout, query: opts.except(:cache_for))
        rescue Timeout::Error => e
          Rails.logger.apc "*** HTTPary Timeout ERR: #{e.class} : #{e.to_s}", :error
          raise APITimeoutError, "API Timeout for #{resource_url} (waited #{((Time.now.to_f - get_start)*1000).to_i} ms)"
        rescue Exception => e
          Rails.logger.apc "*** HTTPary Unknown ERR: #{e.class} : #{e.to_s}", :error
          raise APIError, "Non-timeout API Error for #{resource_url}:\n\n #{e.class} : #{e.to_s}"
        end
      end
      get_end = Time.now.to_f
      Rails.logger.apc "** YvApi.get: Response time: #{((get_end - get_start) * 1000).to_i}ms", :info
    else
      # Just ask the API
      get_start = Time.now.to_f
      begin
        response = httparty_get(resource_url, timeout: timeout, query: opts)
      rescue Timeout::Error => e
        Rails.logger.apc "*** HTTPary Timeout ERR: #{e.class} : #{e.to_s}", :error
        raise APITimeoutError, "API Timeout for #{resource_url} (waited #{((Time.now.to_f - get_start)*1000).to_i} ms)"
      rescue Exception => e
        Rails.logger.apc "*** HTTPary Unknown ERR: #{e.class} : #{e.to_s}", :error
        raise APIError, "Non-timeout API Error for #{resource_url}:\n\n #{e.class} : #{e.to_s}"
      end

      get_end = Time.now.to_f
      Rails.logger.apc "** YvApi.get: Response time: #{((get_end - get_start) * 1000).to_i}ms", :info
    end

    if log_response?
      Rails.logger.apc "** YvApi response: ", :debug
      Rails.logger.apc response, :debug
    end

    # Check the API response for error code
    return api_response_or_rescue(response, block, resource_url: resource_url)
  end

  def self.post(path, opts={}, &block)
    auth_from_opts!(opts)
    timeout = opts.delete(:timeout)
    resource_url = get_resource_url!(path, opts)
    opts = clean_up_opts(opts)
    Rails.logger.apc "** YvApi.post: Calling #{resource_url} with body: ", :info
    Rails.logger.apc opts, :info

    post_start = Time.now.to_f
    begin
      response = httparty_post(resource_url, timeout: timeout, body: opts)
    rescue Timeout::Error => e
      Rails.logger.apc "*** HTTPary Timeout ERR: #{e.class} : #{e.to_s}", :error
      raise APITimeoutError, "API Timeout for #{resource_url} (waited #{((Time.now.to_f - post_start)*1000).to_i} ms)"
    rescue Exception => e
      Rails.logger.apc "*** HTTPary Unknown ERR: #{e.class} : #{e.to_s}", :error
      raise APIError, "Non-timeout API Error for #{resource_url}: #{e.class} : #{e.to_s}"
    end
    post_end = Time.now.to_f

    if log_response?
      Rails.logger.apc "** YvApi.post: Response: ", :debug
      Rails.logger.apc response, :debug
    end

    Rails.logger.apc "** YvApi.post: Resonse time: #{((post_end - post_start) * 1000).to_i}ms", :info
    # Check the API response for error code
    return api_response_or_rescue(response, block)
  end

  def self.to_api_lang_code(lang_code)
    # ["de","en","es","fr","ko","nl","no","pl","pt","ru","sk","sv","zh_CN", "zh_TW"]}, # API options for 2.4 plans 3/26/12
    code = lang_code.to_s.gsub("pt-BR", "pt")
    code = code.gsub("-", "_")

    lang_code.is_a?(Symbol) ? code.to_sym : code
  end

  def self.to_bible_api_lang_code(lang_code)
    code = bible_api_custom_languages[lang_code.to_s]
    code = LanguageList::LanguageInfo.find(lang_code.to_s).try(:iso_639_3) if code.nil?

    lang_code.is_a?(Symbol) ? code.to_sym : code.to_s
  end

  def self.to_app_lang_code(lang_code)
    # ["de","en","es","fr","ko","nl","no","pl","pt","ru","sk","sv","zh_CN", "zh_TW"]}, # API options for 2.4 plans 3/26/12
    lang_code = lang_code.gsub("pt", "pt-BR")
    lang_code = lang_code.gsub("_", "-")
  end

  def self.bible_to_app_lang_code(lang_code)
    code = bible_api_custom_languages.key(lang_code.to_s)
    code ||= LanguageList::LanguageInfo.find(lang_code.to_s).try(:iso_639_1)
    # the code will be empty if not a common or iso 639_1 language
    # or if we don't have the language supported in our custom tags
    # the app won't be able to recognize this code if empty
    # return the code passed so there's at least something?
    code = lang_code if code.to_s == ""
    code
  end

  def self.get_usfm_version(osis_version)
    Cfg.osis_usfm_hash[:versions][osis_version.downcase] if osis_version.is_a? String
  end

  def self.get_usfm_book(osis_book)
    Cfg.osis_usfm_hash[:books][osis_book.downcase] if osis_book.is_a? String
  end

  def self.usfm_delimeter
    "+"
  end

  def self.parse_reference_string(ref_str)
    re =  /^
            \s*
            ([1-3]? \s* [A-Za-z]+)                            #book
            \s*
            (?:(?:[:\.])(\d*))?                               #optional chapter
            \s*
            (?:(?:[:\.]) ([\d\-,\s]*))?                       #optional verse(s)
            \s*
            (?: (?:\.) ((?: \d*\-?)? (?: [0-9a-zA-Z_\-]*)) )?    #optional version
          $/x
    matches = ref_str.match(re)

    {book: matches.try(:[], 1), chapter: matches.try(:[], 2), verses: matches.try(:[], 3), version: matches.try(:[], 4)}
  end

  private
  def self.log_response?
    return false if Rails.env.production?
    return true if ENV["LOG_API_RESPONSES"]
    return false # <=Comment out this line to enable response logging in developent
    return true
  end
  def self.auth_from_opts!(opts)
    # Clear the auth state or it'll keep it around between requests
    default_options.delete(:basic_auth)

    # For login
    basic_auth opts.delete(:auth_username), opts.delete(:auth_password) if (opts[:auth_username] && opts[:auth_password])

    # TODO: Clean up the call around this so it's unnecessary
    a = Hashie::Mash.new(opts.delete(:auth)) if opts[:auth]

    # For auth'ed API calls with :user => current_user
    basic_auth a.username, a.password if a
  end

  def self.clean_up_opts(opts)
    opts[:language_tag] = to_api_lang_code(opts[:language_tag]) if opts[:language_tag]
    opts[:language_iso] = to_api_lang_code(opts[:language_iso]) if opts[:language_iso]

    return opts
  end

  def self.get_resource_url!(path, opts)
    #/likes.youversionapi.com/3.0/view.json
    get_protocol(path) + '://' + get_host!(opts, path) + get_path!(path)
  end

  def self.get_protocol(path)
    # Set the request protocol
    case path
      when /(bible|audio-bible)\//
        'http'
      else
        'https'
    end
  end

  def self.get_host!(opts, path)
    #/likes.youversionapi.com/3.0
    path.match(/(.+)\/.*/).try(:[], 1) + "." + Cfg.api_root + "/" + (opts.delete(:api_version) || Cfg.api_version)
  end

  def self.bible_api_custom_languages
    {
      'en-GB' => 'eng_GB',
      'pt'    => 'por_PT',
      'pt-BR' => 'por',
      'zh-CN' => 'cmn',
      'zh-TW' => 'zho',
      'es-ES' => 'spa_ES'
    }
  end

  def self.get_path!(path)
    _path = path.match(/.+\/(.*)/)[1]
    _path = "/" + _path unless _path.match(/^\//)
    _path += ".json" unless _path.match(/\.json$/)
    _path
  end

  def self.api_response_or_rescue(response, block, opts = {})
    if response["response"]["code"].to_i >= 400
      # Check if it's bad/expired auth and raise an exception
      if response["response"]["data"]["errors"].detect { |t| t["error"] =~ /Username\sor\spassword/ }
        raise AuthError
      end
      # If there's a block, use it for a substitute API call
      new_response = block.call(response["response"]["data"]["errors"], response) if block
      # If the block didn't return a substitute array, throw an exception based on the original error
      raise("API Error: " + response["response"]["data"]["errors"].map { |e| e["error"] }.join("; ")) unless !new_response.nil?
      # If it DID work, use the response from the block as the new response
      return new_response
    end

    if response["response"]["code"].nil?
      # If there's a block, use it for a substitute API call
      new_response = block.call(response["response"]["data"]["errors"], response) if block

      # If the block didn't return a substitute, throw an exception based on the original error
      if new_response.nil?
        begin
          if response["response"]["data"]["errors"] && response["response"]["data"]["errors"].first["key"] == "unknown_error"
            Rails.logger.apc "*** API Server ERR", :error
            Rails.logger.apc "**** Error: #{response["response"]["data"]["errors"].first["error"]}", :error
            Rails.logger.apc "**** Response: #{response}", :error
            unknown_error =  response["response"]["data"]["errors"].first["error"]
          end
        rescue
          Rails.logger.apc "*** Uncoded API ERR", :error
          Rails.logger.apc "**** Response: #{response}", :error
          raise APIError, "Uncoded API error for #{opts[:resource_url]}"
        end

        raise APIError, "'Unknown' API error for #{opts[:resource_url]}:\n'#{unknown_error}'" if unknown_error
      end
    end

    # creating a resource? Just return success
    # -- Won't work because we need to 'show' the newly created record and we would not have the ID yet. Commented -- Caedmon
    # return true if response["response"]["code"] == 201
    return true if (response["response"]["code"] ==  201 and response["response"]["data"] == "Created")

    return true if response["response"]["code"] == 200 && response["response"]["data"] == "OK"

    # Otherwise, turn the data back into a Mash and return it
    case response["response"]["data"]
      when Array
        if response["response"]["data"].first.respond_to?(:each_pair)
          response["response"]["data"].map {|e| Hashie::Mash.new(e)}
        else
          response["response"]["data"]
        end
      when Hash
        Hashie::Mash.new(response["response"]["data"])
      when Fixnum
        # only for users/user_id
        Hashie::Mash.new({user_id: response["response"]["data"] })
      end
  end
end
