class window.ChannelsController

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id);

    mp_track("mp_page_view", {mp_page: window.location.href})

    withChannel = (channel) ->
      channel.set(new_facts: false)
      callback(channel);

    if (channel)
      withChannel(channel);
    else
      channel = new Channel({created_by:{username: username}, id: channel_id})
      channel.fetch
        success: (model, response) -> withChannel(model)

  setChannels: (channels, channel) ->
    channelCollectionView = new ChannelsView(collection: channels)
    channels.setActiveChannel(channel)
    channels.setupReloading(true)
    FactlinkApp.leftMiddleRegion.show(channelCollectionView)


  commonChannelViews: (channel) ->
    window.currentChannel = channel

    if channel.get('is_normal')
      FactlinkApp.leftBottomRegion.show(new RelatedChannelsView(model: channel))
    else
      FactlinkApp.leftBottomRegion.close()

    user = channel.user()
    if user.is_current_user()
      FactlinkApp.leftTopRegion.close()
    else
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)


    if window.Channels.getUsername() isnt user.get('username')
      window.Channels.setUsername(user.get 'username');
    @setChannels(window.Channels, channel)



  getChannelFacts: (username, channel_id) ->
    this.loadChannel username, channel_id, (channel) =>
      this.commonChannelViews(channel)
      FactlinkApp.mainRegion.show(new ChannelView(model: channel))

  getChannelActivities: (username, channel_id) ->
    this.loadChannel username, channel_id, (channel) =>
      this.commonChannelViews(channel);
      activities = new ChannelActivities([],{ channel: channel })
      FactlinkApp.mainRegion.show(new ChannelActivitiesView(model: channel, collection: activities))
