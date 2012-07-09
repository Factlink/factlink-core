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

  setChannels: (channels) ->
    channelCollectionView = new ChannelsView(collection: channels)
    channels.setupReloading();
    FactlinkApp.channelListRegion.show(channelCollectionView)


  commonChannelViews: (channel) ->
    this.setCurrentChannel(channel);

    relatedChannels = new RelatedChannels [], forChannel: channel

    FactlinkApp.relatedChannelsRegion.show(new RelatedChannelsView(model: channel, collection: relatedChannels, addToCollection: window.currentChannel.subchannels()))

    relatedChannels.fetch()

    user = channel.user()
    userView = new UserView(model: user)
    FactlinkApp.userblockRegion.show(userView)

    if window.Channels.getUsername() == user.get('username')
      @setChannels(window.Channels)
    else
      Channels.setUsername(user.get 'username');
      window.Channels.fetch
        success: (channels) => @setChannels(channels)



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