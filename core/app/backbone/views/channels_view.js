window.ChannelsView = Backbone.Marionette.CompositeView.extend({
  template: 'channels/channel_list',
  itemView: ChannelItemView,

  appendHtml: function(collectionView, itemView) {
    var ch = itemView.model;
    if (ch.get('type') !== 'stream' || ch.get('created_by').username === window.currentUser.get('username')){
      collectionView.$('#channel-listing').append(itemView.el);
    }
  }
});
