ProfileController = {

  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;

    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
  },

  showProfile: function(channel) {
    var channelCollectionView = new ChannelCollectionView({collection: window.Channels});
    window.Channels.setUsername(window.currentUser.get('username'));
    this.setupChannelReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView);
    var userView = new UserView({model: window.currentUser});
    FactlinkApp.userblockRegion.show(userView);
  },


}