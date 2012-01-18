var views = {};
var activeChannel;

window.ChannelCollectionView = Backbone.CollectionView.extend({
  el: $('#left-column'),
  
  initialize: function(opts) {
    var self = this;

    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);
    
    // HACK Hacky way to make sure Backbone will refollow the current route
    this.el.find('li.active').live('click', function(e) {
      Backbone.history.loadUrl( Backbone.history.fragment );
    });
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelItemView({model: channel});
    
    views[channel.id] = view;
    
    if ( this.collection.activeChannelId === channel.id ) {
      view.setActive();
    }
    
    this.$('#channel-listing').append(view.render().el);
  },
  
  setLoading: function() {
    this.removeChannels();
    this.el.find('.add-channel').hide();
  },

  resetChannels: function() {
    var self = this;
    
    this.removeChannels();
    
    this.collection.each(function(channel) {
      self.addOneChannel.call(self, channel);
    });
    $('div.twipsy').remove();
  },
  
  removeChannels: function() {
    _.each(views,function(view) {
      view.remove();
    });
  },

  render: function() {
    this.resetChannels();
    
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
