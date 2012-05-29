window.AutoCompletedChannelView = Backbone.Marionette.ItemView.extend(
  tagName: "li"

  triggers:
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"

  template: "channels/_auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> @title.replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if @model.get('user_channel' )
      @$el.addClass('user-channel')

  activate: ->
    @$el.addClass 'active'

  deActivate: ->
    @$el.removeClass 'active'

)
