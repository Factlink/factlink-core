window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    this.channelCollectionView = new ChannelCollectionView({
      collection: Channels
    }).render();
    
    this.channelView = new ChannelView();
    this.views = [new RelatedUsersView()];
    
    this.setupChannelReloading();
    
    this.userView = new UserView({
      model: ( typeof currentChannel !== undefined ) ? currentChannel.user : currentUser
    })
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
  
  reInit: function(opts) {
    var channel = opts.model;
    var oldChannel = currentChannel;
    
    window.currentChannel = channel;
    
    if ( channel.user.id !== oldChannel.user.id ) {
      this.channelCollectionView.reload(currentChannel.id);
    }
    
    for(var i = 0; i < this.views.length; i++){
      this.views[i] = this.views[i].reInit({model: channel});
    }
    this.userView = this.userView.reInit({model:channel.user})
    this.channelView = this.channelView.reInit({model: channel});
    
    return this;
  },
  
  render: function() {
    for(var i = 0; i < this.views.length; i++){
      this.views[i].render();
    }
    this.userView.render();
    $('#main-wrapper').html( this.channelView.el );
  },
  
});
