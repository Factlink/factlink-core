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
    if @model.get('user_channel' )
      @$el.addClass('user-channel')

  deactivate: -> @$el.removeClass 'active'
  activate: ->
    @$el.addClass 'active'
    @scrollIntoView()

  scrollIntoView: ->
    container = @$el.closest("ul")[0]
    if (container.scrollHeight > container.clientHeight)
      @el.scrollIntoView(false)
