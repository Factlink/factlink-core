class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate"

  template: "channels/_auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

    @on 'activate', => @activate()
    @on 'deactivate', => @deactivate()

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if @model.existingChannelFor(currentUser)
      @$el.addClass('user-channel')

  deactivate: -> @$el.removeClass 'active'
  activate: ->
    @$el.addClass 'active'
    @scrollIntoView()

  scrollIntoView: -> scrollIntoViewWithinContainer(@el, @$el)