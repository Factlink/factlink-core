class window.AutoCompletedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"

  template: "channels/_auto_completed_channel"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")
    @on 'activate', -> @$el.addClass 'active'
    @on 'deactivate', -> @$el.removeClass 'active'

    @on 'mouseEnter', -> @options.parent.activateAutoCompleteView(this);
    @on 'mouseLeave', -> @options.parent.deActivateAutoCompleteView()

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> htmlEscape(@title).replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if @model.get('user_channel' )
      @$el.addClass('user-channel')