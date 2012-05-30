window.ChannelsView = Backbone.Marionette.CompositeView.extend({
  template: 'channels/channel_list',
  itemView: ChannelItemView,

  appendHtml: function(collectionView, itemView) {
    collectionView.$('#channel-listing').append(itemView.el);
  }
});
