app = FactlinkApp

class window.ProfileController

  showProfile: (username) ->
    self = this;
    channelCollectionView = new ChannelsView({collection: window.Channels});
    window.Channels.setUsername(username);
    window.Channels.setupReloading();
    app.channelListRegion.show(channelCollectionView);

    user = new User({username: username});
    user.fetch
      success: () -> self.showUser(user)
      forProfile: true

  showUser: (user) ->
    userLargeView = new UserLargeView({model: user});
    app.userblockRegion.show(userLargeView);

    main = new TabbedMainRegionLayout();
    app.mainRegion.show(main)

    main.titleRegion.show(new TextView({model: new Backbone.Model({text: 'About ' + user.get('username')})}));
    main.tabsRegion.show(new UserTabsView({model: user}));
    main.contentRegion.show(new ProfileView({model: user, collection: this.topChannels()}));

  topChannels: ()->
    topchannels = new ChannelList();
    _.each window.Channels.models, (channel) ->
      if(channel.get('type') == 'channel')
        topchannels.add(channel);

    topchannels.comparator =  (channel) ->
      -parseFloat(channel.get('created_by_authority'));

    topchannels.sort();
    return topchannels;

