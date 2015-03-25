module ApplicationHelper

  # Generate a link to previous chapter
  #
  # @param: [Reference] reference - an instance of Reference
  # @param: [Hash] options - a hash of options
  #
  # @option: [String] classes: a string of classes to add to the generated link
  def reader_next_link(reference, opts={})
    classes = opts.delete(:classes)
    next_chapter  = reference.next_chapter_hash
    link_to( next_chapter.human, reference_path(version: next_chapter.version_id, reference: next_chapter.usfm.first.downcase), class: classes) if next_chapter
  end

  # Generate a link to previous chapter
  #
  # @param: [Reference] reference - an instance of Reference
  # @param: [Hash] options - a hash of options
  #
  # @option: [String] classes: a string of classes to add to the generated link

  def reader_previous_link(reference, opts={})
    classes = opts.delete(:classes)
    prev_chapter  = reference.previous_chapter_hash
    link_to( prev_chapter.human, reference_path(version: prev_chapter.version_id, reference: prev_chapter.usfm.first.downcase), class: classes) if prev_chapter
  end

  def moment_whos_liked_string(moment)
    total_likes = moment.likes.count
    last_liker  = moment.likes.last.user

    # Last liker is me and there are more than 2 likes
    if last_liker.id == current_auth.user_id and total_likes >= 2
      last_liker = moment.likes[total_likes-2].user
    end

    # Check if the user was deleted from the API their username will be nil
    if last_liker.username.blank?
        last_liker_link = content_tag(:a, "", href:"#")
    else
        last_liker_link = content_tag(:a, last_liker.name, href:user_path(last_liker.username))
    end

    if moment.likes_count == 1
      t('moments.user likes this', last_liker_link: last_liker_link).html_safe

    else
      case moment.likes_count - 1
      when 1
        more_link = link_to(t('moments.likes count more', likes_count: (moment.likes_count - 1)), moment.to_path)
      when 2
        more_link = link_to(t('moments.likes count 2 more', likes_count: (moment.likes_count - 1)), moment.to_path)
      else
        more_link = link_to(t('moments.likes count 3 or more', likes_count: (moment.likes_count - 1)), moment.to_path)
      end

      t('moments.users like this', last_liker_link: last_liker_link, more_link: more_link).html_safe
    end
  end


  # Appropriate method to use to check if current_user is the passed in user
  # Using current_auth avoids an extra API call to users#view for current user information
  def current_user_is?( user )
    current_auth && current_auth.username == user.username
  end

  def current_user_moment?(moment)
    moment.user_id == current_auth.user_id
  end

  def is_reader_page?
    controller_name == "references" && action_name == "show" ||
    controller_name == "subscriptions" && action_name == "show" ||
    controller_name == "plans" && action_name == "sample"
  end

  def client_settings
    @client_settings ||= YV::ClientSettings.new(cookies)
  end

  def current_date
    current_user ? (DateTime.now.utc + current_user.utc_date_offset).to_date : Date.today
  end

  def api_dt_time_ago(api_created_dt)
    time = if api_created_dt.is_a?(Fixnum)
      Time.at(api_created_dt)
    else
      DateTime.parse(api_created_dt)
    end
    t('moments.time past', ago: time_ago_in_words(time.in_time_zone))
  end


  def usfm_from_moment(references)
    references.usfm.join("+")
  end

  def available_locales
    @available_locales ||= I18n.available_locales
  end

  def current_locale
    @current_locale ||= I18n.locale
  end

  def localized_bible_icon( size = 48, locale=I18n.locale )
    "icons/bible/#{size.to_s}/#{locale}.png"
  end

  def bible_icon_for_version(opts={})
    opts.reverse_merge!({size: 120})
    lang = opts[:version].language.tag.present? ? opts[:version].language.tag : nil
    lang = "pt" if lang.eql?("pt-BR")
    lang = I18n.locale unless I18n.available_locales.to_s.include? lang #ensure current version lang is available locale
    localized_bible_icon(opts[:size], lang)
  end

  def overwrite_content_for(name, content = nil, &block)
    @view_flow.set(name, ActiveSupport::SafeBuffer.new)
    content_for(name, content, &block)
  end

  def html_attributes( atts = {} )
    classes = [atts[:classes]] if atts[:classes].is_a? String
    @html_id      = atts[:id] if atts[:id]
    @html_classes = classes if classes
  end

  def object_status   #TODO: More useful name? WTF is up with this method.
    status = {}
    status[t('notes.public')] = 'public'
    status[t('notes.friends')] = 'friends'
    status[t('notes.private')] = 'private'
    status[t('notes.draft')] = 'draft'
    status
  end

  def truncate_words(text, length = 30, truncate_string = "...")
    return if text.empty?
    l = length - truncate_string.length
    text.length > length ? text[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : text
  end

  def ref_url(usfm,version)
    "/bible/#{version}/#{usfm.downcase}"
  end

  def i18n_kids_whitelist
    # the following localizations will allow translation for the kids page
    # the others will default to en
    [ :en, :"en-GB", :es, :"zh-CN", :ko, :pt ]
  end

  def app_page_path
    locale_dir = I18n.locale.to_s.eql?("en") ? '' : '/' + I18n.locale.to_s
    "#{locale_dir}/app"
  end

  def blog_url(locale)
    case locale.to_s
      when "zh-TW"
        return "http://blog.youversion.com/zh-hant/" #zh-Hant = TW
      when "zh-CN"
        return "http://blog.youversion.com/zh-hans/" #zh-Hans = CN
      when "nl"
        return "http://blog.youversion.com/nl/"
      when "fr"
        return "http://blog.youversion.com/fr/"
      when "de"
        return "http://blog.youversion.com/de/"
      when "ru"
        return "http://blog.youversion.com/ru/"
      when "es", "es-ES"
        return "http://blog.youversion.com/es/"
      when "ko"
        return "http://blog.youversion.com/ko/"
      when "no"
        return "http://blog.youversion.com/nb/"
      when "pl"
        return "http://blog.youversion.com/pl/"
      when "pt", "pt-PT"
        return "http://blog.youversion.com/pt-br/"
      when "ro"
        return "http://blog.youversion.com/ro/"
      when "sv"
        return "http://blog.youversion.com/sv/"
      else
        return "http://blog.youversion.com/"
    end

  end

  def kids_page_path
    locale_dir = I18n.locale.to_s.eql?("en") ? '' : '/' + I18n.locale.to_s
    "#{locale_dir}/kids"
  end

  def bible_localized_path
    I18n.locale.to_s.eql?("en") ? "/bible" : "/#{I18n.locale}/bible"
  end

  def googleBot?(request)
    if request.user_agent
      !!request.user_agent.match(/Googlebot/i)
    end
  end

  def bible_path(ref=nil, opts={})
    ref = last_read || default_reference if ref.nil?
    ver = opts.delete(:version)
    reference_path(ver, ref, opts)
  end

  def bible_version_path(ref=nil, opts={})
    ref = last_read || default_reference if ref.nil?
    ver = opts[:version_id] || opts[:version] || ref.version
    reference_path(ver, ref, opts)
  end

  def bible_url(ref=nil, opts={})
    ref = last_read || default_reference if ref.nil?
    ver = opts[:version_id] || opts[:version] || ref.version
    reference_url(ver, ref, opts)
  end

  def ref_from_params
    case
    when params.has_key?(:version)
      Reference.new(params[:reference], version: params[:version])
    else
      Reference.new(params[:reference])
    end
  end

  def default_reference
    Reference.new(book: "JHN", chapter: "1", version: current_version) rescue Reference.new('JHN.1', version: @site.default_version)
  end

  def external_url(host, default_locale_path='', locale_paths={})
    host_str = case host
      when :blog
        'http://blog.youversion.com'
      when :support
        'http://help.youversion.com'
      when :now
        'https://www.youversion.com/happening-now'
      else
        host
    end

    path = case
      when locale_paths[I18n.locale]
        locale_paths[I18n.locale]
      when I18n.locale != I18n.default_locale && locale_paths[:default]
        locale_paths[:default]
      else
        default_locale_path
    end

    path.insert(0, '/') unless path.to_s == ''

    query_param = false
    lang_code_str = case host
      when :support
        query_param = true
        delim = path.include?('?') ? '&' : '?'
        "#{delim}lang=#{lang_code(I18n.locale, host)}"
      when :now
        "##{lang_code(I18n.locale, host)}"
      else
        lang_code(I18n.locale, host)
    end

    return "#{host_str}#{path}" if I18n.locale == I18n.default_locale
    return "#{host_str}#{path}#{lang_code_str}" if query_param
    return "#{host_str}/#{lang_code_str}#{path}"
  end

  def convert_to_brightness_value(hex_color)
      (hex_color.scan(/../).map {|color| color.hex}).sum
  end

  def bdc_user?
    @site.class == YV::Sites::Bible rescue false
  end

  def is_dark?(hex_color)
    convert_to_brightness_value(hex_color) <= 382.5 #halfway between black (0+0+0 = 0) and white (255+255+255 = 765)
  end

  def is_rtl?
    I18n.locale.to_s.eql?("fa") or I18n.locale.to_s.eql?("ar")
  end

  def is_whitelabel_site
    @site.to_s != "Bible(dot)com"
  end

  def get_localized_reference_link(reference, a_locale)
    version = reference.version

    if reference.verses.nil? || reference.verses.empty? then
      fullpath = "/#{version}/#{reference.book.downcase}.#{reference.chapter}.#{reference.version_string.downcase}"
    else
      fullpath = "/#{version}/#{reference.book.downcase}.#{reference.chapter}.#{reference.verses.first}-#{reference.verses.last}.#{reference.version_string.downcase}" if reference.verses.length > 1
      fullpath = "/#{version}/#{reference.book.downcase}.#{reference.chapter}.#{reference.verses.first}.#{reference.version_string.downcase}" if reference.verses.length == 1
    end
    fullpath
  end

  def get_verse_content(html_verse_content)
    doc = Nokogiri::HTML(html_verse_content)
    return doc.css('.content').text
  end

  private
  def lang_code(locale, host=nil)
    case host
      when :blog
        {:'zh-CN' => 'zh-hans', :'zh-TW' => 'zh-hant', :'pt-BR' => 'pt-br'}[locale] || locale
      when :support, :generic_i18n
        locale.to_s.gsub('pt-BR', 'pt').gsub('-','_')
      when :now
        locale.to_s.gsub('pt-BR', 'pt')
      else
        locale
    end
  end
end
