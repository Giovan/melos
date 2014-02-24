window.Panes ?= {}

class window.Panes.Base

  constructor: (@params)->
    @el               = $(@params.el)
    @form_el          = @el.find("form")
    @references_field = @el.find(".verses_selected_input")

  # Some panes have a form with references field that we need
  # to update whenever clicks happen in the reader
  updateForm: (data) ->
    refs = data.references || [];
    @references_field.val refs.join("+") # populate hidden field
    return


  # Get the pane element, in this case a <dd> from the template.
  pane: ()->
    if @pane_el? then return @pane_el else return @el

  # We can set this Pane instances pane element to a different element
  # Currently being used for showing registration pane when a user isn't logged in
  setPane: (pane)->
    @pane_el = pane
    return

  # Compile our template via Handlebars, and render to html
  render: ()->
    if @template
      t = Handlebars.compile @template.html()
      html = t()
      return html

  # After render needs to be manually called at the moment.
  # Usually called from implementation class that overrides 
  # #render and #afterRender methods.
  afterRender: (html)->
    # siblings because html is a 2 node fragment, rather than a container
    fragment          = $(html)
    @el               = fragment.siblings(@params.el)
    @trigger_el       = fragment.siblings("dt")
    @form_el          = @el.find("form")
    @references_field = @el.find(".verses_selected_input")

    @setupClickHandlers()
    return

  setupClickHandlers: ()->
    if @trigger_el.length
      @trigger_el.click (event)=>
        if @trigger_el.hasClass("active")
          @trigger("pane:close", {pane: @})
        else
          @trigger("pane:open", {pane: @})

  # Show the pane <dd>
  open: (complete)->
    @showRegistrationInfo() unless Session.User.isLoggedIn()
    @trigger_el.addClass("active")
    @pane().slideDown 250, complete

  # Hide the pane <dd>
  close: (complete)->
    @trigger_el.removeClass("active")
    @pane().slideUp 250, complete

  # Customize registration pane if logged in
  showRegistrationInfo: ()->
    @pane().find(".blurbs p").hide()
    @pane().find('.blurbs p.' + @trigger_el.data("pane-type")).show()


  # Utility method to trigger a jQuery event.
  trigger: (event, args)->
    $.event.trigger(event, args)
    return

  resetForm: (form)->
    # override this in subclasses to reset/clear forms properly

  triggerFormSuccess: ()->
    $(@).trigger("form:submit:success")


  showFormSuccess: ()->
    pane = @el.find(".pane")
    form = pane.find("form")
    mssg = pane.find(".success")
    
    mssg.show()
    form.hide()
    
    finishedWithSuccess = ()=>
      @triggerFormSuccess()
      @resetForm(form)
      form.show()
      mssg.hide()
    
    setTimeout(finishedWithSuccess, 3000)
    return


  setupColorpicker: ()->
    new Forms.ColorPicker(@form_el)
    return