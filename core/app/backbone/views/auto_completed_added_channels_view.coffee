class window.AutoCompletedAddedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a.icon-remove": "remove"

  template: "channels/auto_completed_added"

class window.AutoCompletedAddedChannelsView extends Backbone.Marionette.CollectionView
  itemView: AutoCompletedAddedChannelView
  tagName: 'ul'
  className: 'added_channels'

  initialize: ->
    @on "itemview:remove", (childView, msg) =>
      @options.mainView.trigger 'removeChannel', childView.model
      @collection.remove childView.model
