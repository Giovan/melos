class VersionsController < ApplicationController

  before_filter -> { set_cache_headers 'short' }, only: [:index]
  before_filter -> { set_cache_headers 'long' }, only: [:show]

  def index
    @versions_by_lang = Version.all_by_language({:only => @site.versions})
    primary_locale = Version.find(params[:context_version]).language.tag rescue nil if params[:context_version].present?
    primary_locale ||= I18n.locale.to_s
    primary_locale = "en" if primary_locale == "en-GB" #TODO fix.this.hack
    primary_locale = "pt-BR" if primary_locale == "pt"
    cur_lang = Hash[primary_locale, @versions_by_lang.delete(primary_locale)]

    if params[:single_locale].present?
      @versions_by_lang = cur_lang
    else
      @versions_by_lang = cur_lang.merge(@versions_by_lang)
    end

    self.sidebar_presenter = Presenter::Sidebar::Versions.new(@versions_by_lang,params,self)

    if params[:single_locale].present?
      render 'index-single-locale'
    end
  end

  def show
    respond_to do |format|
      format.json {
        @version = Version.get("bible/version", {id: params[:id] })
        return render json: @version
      }

      format.any {
        @version = Version.find(params[:id])
        @related = Version.all_by_publisher[@version.publisher_id].find_all{|v| v.language.tag == @version.language.tag}
        @related = @related - [@version] if @related
        self.sidebar_presenter = Presenter::Sidebar::Version.new(@version,params,self)
        return
      }
    end
  end
end
