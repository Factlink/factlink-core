var activeChannel;

window.ChannelCollectionView = Backbone.CollectionView.extend({
  el: $('#left-column'),

  containerSelector: '#channel-listing',

  initialize: function(opts) {
    var self = this;
    this.modelView = ChannelItemView;

    this.collection.bind('add',   this.add, this);
    this.collection.bind('reset', this.reset, this);

    // HACK Hacky way to make sure Backbone will refollow the current route
    this.el.find('li.active').live('click', function(e) {
      Backbone.history.loadUrl( Backbone.history.fragment );
    });
  },

  afterAddBeforeRender: function(model,view){
    if ( this.collection.activeChannelId === model.id ) {
      view.setActive();
    }
  },


  setLoading: function() {
    this.reset();
    this.el.find('.add-channel').hide();
  },

  afterReset: function() {
    $('div.twipsy').remove();
  },

  render: function() {
    var self = this;

    this.collection.each(function(channel) {
      self.add.call(self, channel);
    });

    //TODO: this check is not the same as the check in the backend
    if ( typeof currentChannel !== "undefined" && currentChannel.user.id === currentUser.id ) {
      this.el.find('.add-channel').show();
    } else {
      this.el.find('.add-channel').hide();
    }

    return this;
  },

  reload: function(id) {
    this.collection.activeChannelId = id;

    this.setLoading();
    Channels.fetch();
  }
});
