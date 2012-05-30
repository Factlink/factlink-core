window.ProfileView = Backbone.Marionette.CompositeView.extend({
  template: 'users/profile',

  initialize: function() {
    this.itemView = TopChannelView
  },

  appendHtml: function(collectionView, itemView) {
    collectionView.$('.top-channels ol').append(itemView.el);
  },

  onRender: function() {
    if (this.collection.length > 0) {
      this.$('.no-channels').hide();
      this.$('.top-channels').show();
    } else {
      this.$('.top-channels').hide();
      this.$('.no-channels').show();
    }
  }
});
