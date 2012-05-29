window.AutoCompletedChannelView = Backbone.Marionette.ItemView.extend(
  tagName: "li"

  triggers:
    "mouseenter": "mouseEnter",
    "mouseleave": "mouseLeave"

  template: "channels/_auto_completed_channel"

  initialize: ->
    this.queryRegex = new RegExp(this.options.query, "gi")

  templateHelpers: ->
    view = this
    return { highlightedTitle: -> this.title.replace(view.queryRegex, "<em>$&</em>")}

  onRender: ->
    if this.model.get('user_channel' )
      this.$el.addClass('user-channel')

  activate: ->
    this.$el.addClass 'active'

  deActivate: ->
    this.$el.removeClass 'active'

)
