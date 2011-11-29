window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    this.channelCollectionView = new ChannelCollectionView({
      collection: Channels
    }).render();
    
    this.relatedUsersView = new RelatedUsersView();
    
    this.activitiesView = new ActivitiesView();
    
    this.setupChannelReloading();
    
    this.changeUser(currentChannel.user);
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
  
  openChannel: function(channel) {
    var self = this;
    var oldChannel = currentChannel;
    
    window.currentChannel = channel;
    
    if ( channel ) {
      if ( channel.user.id !== oldChannel.user.id ) {
        this.changeUser(channel.user);
        
        this.channelCollectionView.reload(currentChannel.id);
      }
      
      this.channelView = new ChannelView({model: channel}).render();
      
      this.relatedUsersView
            .setChannel(channel)
            .render();
      
      this.activitiesView
            .setChannel(channel)
            .render();
    }
  },
  
  changeUser: function(user) {
    if ( this.userView ) {
      this.userView.close();
    }
    
    this.userView = new UserView({model: user}).render();
  }
});
