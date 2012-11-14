app = FactlinkApp

class window.ChannelsController extends Backbone.Factlink.BaseController

  routes: ['getChannelFacts', 'getChannelFact', 'getChannelActivities', 'getChannelFactForActivity']

  onShow: ->
    @channel_views = new Backbone.Factlink.DetachedViewCache

  onClose: ->
    @channel_views.cleanup()

  onAction: ->
    @unbindFrom @permalink_event if @permalink_event?

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
    app.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      @makePermalinkEvent(channel.url())

      if not @channel_views.switchCacheView(channel_id)?
        @channel_views.clear()
        channel_view = new ChannelView(model: channel)
        @channel_views.renderCacheView(channel_id, channel_view)


  getChannelActivities: (username, channel_id) ->
    app.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      @makePermalinkEvent(channel.url() + '/activities')

      if not @channel_views.switchCacheView(channel_id)?
        @channel_views.clear()
        activities = new ChannelActivities([],{ channel: channel })
        channel_activities_view = new ChannelActivitiesView(model: channel, collection: activities)
        @channel_views.renderCacheView(channel_id, channel_activities_view)

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, true)

  getChannelFact: (username, channel_id, fact_id, for_stream=false) ->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    channel = `undefined`
    fact = `undefined`

    with_both = =>
      return_to_url = channel.url()
      return_to_url = return_to_url + "/activities" if for_stream

      title_view = new ExtendedFactTitleView(
                                      model: fact,
                                      return_to_url: return_to_url,
                                      return_to_text: channel.get('title') )
      @main.titleRegion.show( title_view )

    callback_with_both = _.after 2, with_both

    @loadChannel username, channel_id, ( ch ) =>
      channel = ch
      @commonChannelViews( ch )
      callback_with_both()

    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) =>
        window.efv = new ExtendedFactView(model: model)
        @main.contentRegion.show(efv)
        callback_with_both()

  makePermalinkEvent: (baseUrl) ->
    @permalink_event = @bindTo FactlinkApp.vent, 'permalink_clicked', (e, fact_id) =>
      navigate_to = baseUrl + "/facts/" + fact_id
      Backbone.history.navigate navigate_to, true

      e.preventDefault()
      e.stopPropagation()
