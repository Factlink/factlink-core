class SuggestedChannelsEmptyView extends Backbone.Marionette.ItemView
  template:
    text: "No suggestions available."

class SuggestedChannelView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: "channels/suggested_channel"

class window.SuggestedChannelsView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: SuggestedChannelView
  className: 'add-to-channel-suggested-channels'

  emptyView: SuggestedChannelsEmptyView
