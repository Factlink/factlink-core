ChannelsController = {

  loadChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    Channels.setUsername(username);

    try {
      mpmetrics.track("mp_page_view", {
        mp_page: window.location.href
      });
    } catch(e) {}

    if ( !channel ) {
      channel = this.view.channelView.subchannels.get(channel_id);
      channel.collection = Channels;
    }
    channel.set({new_facts: false});
    return channel;
  },

  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;

    if ( typeof localStorage === "object"
      && localStorage !== null
      && localStorage['reload'] === "false" ) {
      return;
    }

    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 60000);
  },

  commonChannelViews: function(channel) {
    FactlinkApp.relatedUsersRegion.show(new RelatedUsersView({model: channel}));
    var channelCollectionView = new ChannelCollectionView({collection: window.Channels});
    this.setupChannelReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView);
    var userView = new UserView({model: channel.user});
    FactlinkApp.userblockRegion.show(userView);
  },

  getChannelFacts: function(username, channel_id) {
    var channel = this.loadChannel(username, channel_id);
    this.commonChannelViews(channel);
    FactlinkApp.mainRegion.show(new ChannelView({model: channel}));
  },

  getChannelActivities: function(username, channel_id) {
    var channel = this.loadChannel(username, channel_id);
    this.commonChannelViews(channel);
    FactlinkApp.mainRegion.show(new ChannelActivitiesView({model: channel}));
  }

}
