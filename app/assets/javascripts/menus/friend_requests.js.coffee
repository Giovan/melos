window.Menus ?= {}

class window.Menus.FriendRequests extends window.Menus.Base
  # Constructor
  # ------------------------------------------------------------

  constructor: (@trigger_el, @base_element) ->
    
    @api_url    = "/friendships/requests.json"
    @template   = $("#friend-requests-tmpl")
    
    @popover    = $(@trigger_el).next('.header-popover')


    $(@trigger_el).click (e)=>
      e.preventDefault()

      if this.isVisible()
         this.close()
      else
         this.open()
      
      return

  # Visibility of menu
  # ------------------------------------------------------------    

  isVisible: ->
    $(@trigger_el).hasClass("active")



  load: ->
    request = $.ajax @api_url,
      type: "GET"
      dataType: "json"

    request.done (data) =>
      template = Handlebars.compile(@template.html())
      $(@base_element).html(template(data))
      return

    request.fail (jqXHR,status) =>
      alert "Failed friend request" + status

    return
    

  # Open menu & load notifications
  # ------------------------------------------------------------

  open: ->
    @popover.show().animate({'opacity' : '1'}, 200);
    this.load()
    $(@trigger_el).addClass("active")
    this.trigger("yv:menu:open", {target: this})
    return


  # Close menu
  # ------------------------------------------------------------

  close: ->
    @popover.animate({'opacity' : '0'}, 200);
    $(@trigger_el).removeClass("active")
    this.trigger("yv:menu:close",{target: this})
    return