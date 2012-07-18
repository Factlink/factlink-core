#= require ./channel_item_view.js

class window.ChannelsView extends Backbone.Marionette.CompositeView
  template: 'channels/channel_list',
  itemView: ChannelItemView,

  appendHtml: (collectionView, itemView) ->
    ch = itemView.model
    if (ch.get('type') != 'stream' || ch.get('created_by').username == window.currentUser.get('username'))
      collectionView.$('#channel-listing').append(itemView.el);
