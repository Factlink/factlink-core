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

  commonChannelViews: (channel) ->
    window.currentChannel = channel

    @showRelatedChannels channel
    @showUserProfile channel.user()
    @showChannelSideBar window.Channels, channel, channel.user()

  showRelatedChannels: (channel)->
    if channel.get('is_normal')
      FactlinkApp.leftBottomRegion.show(new RelatedChannelsView(model: channel))
    else
      FactlinkApp.leftBottomRegion.close()

  showChannelSideBar: (channels, currentChannel, user)->
    window.Channels.setUsernameAndRefresh(user.get('username'))
    channelCollectionView = new ChannelsView(collection: channels, model: user)
    FactlinkApp.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActiveChannel(currentChannel)

  showUserProfile: (user)->
    unless user.is_current_user()
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)
    else
      FactlinkApp.leftTopRegion.close()

  getChannelFacts: (username, channel_id) ->
    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      FactlinkApp.mainRegion.show(new ChannelView(model: channel))

  getChannelActivities: (username, channel_id) ->
    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      activities = new ChannelActivities([],{ channel: channel })
      FactlinkApp.mainRegion.show(new ChannelActivitiesView(model: channel, collection: activities))
