class AutoCompleteResultsChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a.icon-remove": "remove"

  template: "channels/auto_complete_results_channel"

class window.AutoCompleteResultsChannelsView extends Backbone.Marionette.CollectionView
  itemView: AutoCompleteResultsChannelView
  tagName: 'ul'
  className: 'added_channels'

  initialize: ->
    @on "itemview:remove", (childView, msg) => @collection.remove childView.model
