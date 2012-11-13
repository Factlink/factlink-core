app = FactlinkApp

class window.ChannelsController

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id)

    mp_track("mp_page_view", {mp_page: window.location.href})

    withChannel = (channel) ->
      channel.set(new_facts: false)
      callback(channel)

    if (channel)
      withChannel(channel)
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
      app.leftBottomRegion.show(new RelatedChannelsView(model: channel))
    else
      app.leftBottomRegion.close()

  showChannelSideBar: (channels, currentChannel, user)->
    window.Channels.setUsernameAndRefresh(user.get('username'))
    channelCollectionView = new ChannelsView(collection: channels, model: user)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActiveChannel(currentChannel)

  showUserProfile: (user)->
    unless user.is_current_user()
      userView = new UserView(model: user)
      app.leftTopRegion.show(userView)
    else
      app.leftTopRegion.close()

  getChannelFacts: (username, channel_id) ->
    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      app.mainRegion.show(new ChannelView(model: channel))

  getChannelActivities: (username, channel_id) ->
    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      activities = new ChannelActivities([],{ channel: channel })

      app.mainRegion.show(new ChannelActivitiesView(model: channel, collection: activities))

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, true)

  getChannelFact: (username, channel_id, fact_id, for_stream=false) ->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @loadChannel username, channel_id, ( channel ) =>
      @commonChannelViews( channel )

      fact = new Fact(id: fact_id)
      fact.fetch
        success: (model, response) =>
          window.efv = new ExtendedFactView(model: model)
          @main.contentRegion.show(efv)

          return_to_url = channel.url()
          return_to_url = return_to_url + "/activities" if for_stream

          title_view = new ExtendedFactTitleView(
                                          model: fact,
                                          return_to_url: return_to_url,
                                          return_to_text: channel.get('title') )
          @main.titleRegion.show( title_view )
