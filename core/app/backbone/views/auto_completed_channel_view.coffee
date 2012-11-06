class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate"

  template: "channels/auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

    @on 'activate', => @activate()
    @on 'deactivate', => @deactivate()

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    @$el.addClass('user-channel') if @model.existingChannelFor(currentUser)


  deactivate: -> @$el.removeClass 'active'
  activate: ->
    @$el.addClass 'active'
    @scrollIntoView()

  scrollIntoView: -> scrollIntoViewWithinContainer(@el, @$el)
