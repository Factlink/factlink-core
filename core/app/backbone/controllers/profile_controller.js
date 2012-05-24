window.ProfileController = {

  // TODO: This function needs to wait for loading (Of channel contents in main column)
  setupChannelReloading: function(){
    var args = arguments;

    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
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
    var userView = new UserView({model: user});
    FactlinkApp.userblockRegion.show(userView);

    var mainLayout = new TabbedMainRegionLayout();
    mainLayout.render();

    mainLayout.titleRegion.show(new TextView({model: new Backbone.Model({text: 'HOI'})}));
    FactlinkApp.mainRegion.show(mainLayout);
  }


};