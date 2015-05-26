module Presenter
  class Reference < Presenter::Base

    include Presenter::ReaderInterface

    attr_accessor :reference, :alt_reference, :version, :alt_version, :subscriptions
    
    def initialize( ref_string, params = {}, controller = nil, opts = {})
      super(params,controller)
      @reference_string = ref_string
      @reference        = ::Reference.new(reference_hash)
      @version          = Version.find(reference.version)
      @alt_version      = opts[:alt_version]   || Version.find(controller.send(:alt_version,reference))
      @alt_reference    = opts[:alt_reference] || ::Reference.new(reference, version: alt_version)
    end

    def content
      reference.content(chapter: verses.blank?)
    end

    def valid_reference?
      @reference.valid?
    end

    def reference_string
      @reference_string
    end

    def reference_hash
      @reference_hash ||= @reference_string.to_hash
    end

    def is_chapter?
      @reference_string.verses.blank?
    end

    def note
      # Create an empty note for the note sidebar widget
      @note ||= Note.new(version_id: version.id)
    end

    def subscriptions
      # used in sidebar partial
      current_user = controller.send(:current_user)
      ::Subscription.all(current_user, cache_for: YV::Caching.a_short_time) if current_user.present?
    end

    # implementation for Presenter::ReaderInterface method
    def verses
      reference_string.verses
    end

    # implementation for Presenter::ReaderInterface method
    def modal_verse
      nil
    end

  end

end