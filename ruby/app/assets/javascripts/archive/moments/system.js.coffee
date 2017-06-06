window.Moments ?= {}

class window.Moments.System extends window.Moments.Base

  constructor: (@data, @feed)->
    @template = JST["moments/system"]
    @feed.ready(@)

  render: ()->
    if @template

      html = @template
        uuid:           @generateID()
        created_dt:     @data.created_dt
        moment_title:   @data.moment_title
        body_text:      @data.body_text
        body_image:     @data.body_image
        avatar:         @data.avatar
        avatar_style:   @data.avatar_style
        action_url:     @data.action_url
        kind_color:     @data.kind_color

      return html