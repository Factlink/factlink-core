window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    this.channelCollectionView = new ChannelCollectionView({appView: this});
    this.relatedUsersView = new RelatedUsersView({appView: this});
    this.channelView = new ChannelView({appView: this});
    
    this.channelCollectionView.render();
    
    this.setupChannelReloading();
  },
  
  // TODO: This function needs to wait for loading
  setupChannelReloading: function(){
    var args = arguments;
    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
  },
  
  openChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    var self = this;
    
    if ( channel ) {
      this.channelView.setChannel(channel).render();
    }
  }
});
