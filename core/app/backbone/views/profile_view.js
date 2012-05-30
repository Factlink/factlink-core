window.ProfileView = Backbone.Marionette.CompositeView.extend({
  template: 'users/profile',
  events: {
    'click a.show-more': 'showMore',
    'click a.show-less': 'showLess'
  },

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
  },

  showMore: function() {
    this.$('a.show-more').hide();
    this.$('a.show-less').show();
    this.$('.top-channels ol').addClass('show-all');
  },

  showLess: function() {
    this.$('a.show-less').hide();
    this.$('a.show-more').show();
    this.$('.top-channels ol').removeClass('show-all');
  }

});
