var activeChannel;

window.ChannelCollectionView = Backbone.CollectionView.extend({
  views: {},

  containerSelector: '#channel-listing',

  initialize: function(opts) {
    var self = this;

    this.setElement($('#left-column'));

    this.modelView = ChannelItemView;

    this.collection.bind('add',   this.add, this);
    this.collection.bind('reset', this.reset, this);
  },

  afterAddBeforeRender: function(model,view) {
    if ( this.collection.activeChannelId === model.id ) {
      view.setActive();
    }
  },

  setLoading: function() {
    this.reset();
    this.$el.find('.add-channel').hide();
  },

  afterReset: function() {
    $('div.tooltip',this.$el).remove();
  },

  render: function() {
    var self = this;

    this.collection.each(function(channel) {
      self.add.call(self, channel);
    });

    //TODO: this check is not the same as the check in the backend
    if ( typeof currentChannel !== "undefined" && currentChannel.user.id === currentUser.id ) {
      this.$el.find('.add-channel').show();
    } else {
      this.$el.find('.add-channel').hide();
    }

    return this;
  },

  reload: function(id) {
    this.collection.activeChannelId = id;

    this.setLoading();
    Channels.fetch();
  }
});
