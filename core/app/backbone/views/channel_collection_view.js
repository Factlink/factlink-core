var activeChannel;

window.ChannelCollectionView = Backbone.Marionette.CompositeView.extend({
  template: 'channels/channel_list',
  itemView: ChannelItemView,

  initialize: function(opts) {
    var self = this;

    this.collection.bind('add',   this.add, this);
    this.collection.bind('reset', this.reset, this);
  },

  appendHtml: function(collectionView, itemView) {
    collectionView.$('#channel-listing').append(itemView.el);
  }

});
