class window.ChannelsController

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id);
    Channels.setUsername(username);

    mp_track("mp_page_view", {mp_page: window.location.href})

    withChannel = (channel) ->
      console.info 'yoyo'
      channel.set(new_facts: false)
      callback(channel);

    if (channel)
      withChannel(channel);
    else
      console.info 'yo'
      channel = new Channel({username: username, id: channel_id})
      channel.fetch
        success: (model, response) -> withChannel(model)

  commonChannelViews: (channel) ->
    this.setCurrentChannel(channel);
    FactlinkApp.relatedUsersRegion.show(new RelatedUsersView(model: channel))
    channelCollectionView = new ChannelsView(collection: window.Channels)
    window.Channels.setupReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView)
    userView = new UserView(model: channel.user)
    FactlinkApp.userblockRegion.show(userView)

  getChannelFacts: (username, channel_id) ->
    this.loadChannel username, channel_id, (channel) =>
      this.commonChannelViews(channel)
      FactlinkApp.mainRegion.show(new ChannelView(model: channel))

  getChannelActivities: (username, channel_id) ->
    this.loadChannel username, channel_id, (channel) =>
      this.commonChannelViews(channel);
      FactlinkApp.mainRegion.show(new ChannelActivitiesView(model: channel));

  setCurrentChannel: (channel) ->
    window.currentChannel = channel