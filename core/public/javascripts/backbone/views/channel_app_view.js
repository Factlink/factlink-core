window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    this.channelCollectionView = new ChannelCollectionView({appView: this});
    this.relatedUsersView = new RelatedUsersView({appView: this});
    this.activitiesView = new ActivitiesView({appView: this});
    
    this.setupChannelReloading();
  },
  
  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;
    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
  },
  
  openChannel: function(username, channel) {
    window.currentChannel = channel;
    var self = this;
    
    if ( currentChannel ) {
      this.channelView = new ChannelView({model: currentChannel}).render();
      
      this.relatedUsersView
            .setChannel(currentChannel)
            .render();
      
      this.activitiesView
            .setChannel(currentChannel)
            .render();
    }
  }
});
