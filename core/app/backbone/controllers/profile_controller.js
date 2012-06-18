window.ProfileController = {

  showProfile: function(username) {
    var self = this;
    var channelCollectionView = new ChannelsView({collection: window.Channels});
    window.Channels.setUsername(username);
    window.Channels.setupReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView);

    var user = new User({username: username});
    user.fetch({success: function(){self.showUser(user);}, forProfile: true});
  },

  showUser: function(user) {
    var userLargeView = new UserLargeView({model: user});
    FactlinkApp.userblockRegion.show(userLargeView);

    var mainLayout = new TabbedMainRegionLayout();
    FactlinkApp.mainRegion.show(mainLayout);

    mainLayout.titleRegion.show(new TextView({model: new Backbone.Model({text: 'About ' + user.get('username')})}));
    mainLayout.tabsRegion.show(new UserTabsView({model: user}));
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
      return -parseFloat(channel.get('created_by_authority'));
    }
    topchannels.sort();
    return topchannels;
  }

};
