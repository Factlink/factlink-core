window.ProfileView = Backbone.Marionette.CompositeView.extend({
  template: 'users/profile',
  className: 'profile',

  events: {
    'click a.show-more': 'showMoreOn',
    'click a.show-less': 'showMoreOff'
  },

  initialize: function() {
    this.itemView = TopChannelView
    this.addClassToggle('showMore');
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
    if (this.collection.length < 6) {
      this.$('.top-channels .show-more').hide();
    }
  },

});
_.extend(ProfileView.prototype,ToggleMixin);