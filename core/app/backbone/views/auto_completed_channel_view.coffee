class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"

  template: "channels/_auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")
    this.on 'activate', -> @$el.addClass 'active'
    this.on 'deactivate', -> @$el.removeClass 'active'

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> @title.replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if @model.get('user_channel' )
      @$el.addClass('user-channel')