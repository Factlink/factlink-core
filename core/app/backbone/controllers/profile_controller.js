window.ProfileController = {

  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;

    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 60000);
  },

  showProfile: function(username) {
    var self = this;
    var channelCollectionView = new ChannelCollectionView({collection: window.Channels});
    window.Channels.setUsername(username);
    this.setupChannelReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView);

    var user = new User({username: username});
    user.fetch({success: function(){self.showUser(user);}, forProfile: true});
  },

  showUser: function(user) {
    var userLargeView = new UserLargeView({model: user});
    FactlinkApp.userblockRegion.show(userLargeView);

    var mainLayout = new TabbedMainRegionLayout();
    mainLayout.render();

    mainLayout.titleRegion.show(new TextView({model: new Backbone.Model({username: 'HOI'})}));
    FactlinkApp.mainRegion.show(mainLayout);

    mainLayout.contentRegion.show(new ProfileView({model: user, collection: this.topChannels()}));
  },

  topChannels: function() {
    var topchannels = new ChannelList();
    _.each(window.Channels.models, function(channel){
      if(channel.get('type') === 'channel'){
        topchannels.add(channel);
      }
    });

    topchannels.comparator = function(channel) {
      return channel.get('created_by_authority');
    }
    topchannels.sort();
    return topchannels;
  }

};
