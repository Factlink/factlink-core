app = FactlinkApp

class window.ProfileController

  showProfile: (username) ->
    channelCollectionView = new ChannelsView(collection: window.Channels)
    window.Channels.setUsername(username)
    window.Channels.setupReloading()
    window.Channels.unsetActiveChannel()
    app.leftMiddleRegion.show(channelCollectionView)

    user = new User(username: username)
    user.fetch
      success: () => @showUser(user)
      forProfile: true

  showUser: (user) ->
    userLargeView = new UserLargeView(model: user);
    app.leftTopRegion.show(userLargeView);

    main = new TabbedMainRegionLayout();
    app.mainRegion.show(main)

    main.titleRegion.showTitle('About ' + user.get('username'))
    main.tabsRegion.show(new UserTabsView(model: user))
    main.contentRegion.show(new ProfileView(
      model: user,
      collection: window.Channels.orderedByAuthority();
    ))