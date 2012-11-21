app = FactlinkApp

class window.ChannelsController extends Backbone.Factlink.BaseController

  routes: ['getChannelFacts', 'getChannelFact', 'getChannelActivities', 'getChannelFactForActivity']

  onShow:   -> @channel_views = new Backbone.Factlink.DetachedViewCache
  onClose:  -> @channel_views.cleanup()
  onAction: -> @unbindFrom @permalink_event if @permalink_event?

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

      @restoreChannelView channel_id, => new ChannelView(model: channel)

  getChannelActivities: (username, channel_id) ->
    app.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      @makePermalinkEvent(channel.url() + '/activities')

      @restoreChannelView channel_id, =>
        activities = new ChannelActivities([],{ channel: channel })
        new ChannelActivitiesView(model: channel, collection: activities)

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, true)

  getChannelFact: (username, channel_id, fact_id, for_stream=false) ->
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
        dv = new DiscussionView(model: model)
        @main.contentRegion.show(dv)
        callback_with_both()

  restoreChannelView: (channel_id, new_callback) ->
    view = @channel_views.switchCacheView(channel_id)
    $('body').scrollTo(@lastChannelStatus.scrollTop) if view == @lastChannelStatus?.view
    delete @lastChannelStatus
    @channel_views.renderCacheView(channel_id, new_callback()) if not view?
    @channel_views.clearUnshowedViews()

  makePermalinkEvent: (baseUrl) ->
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', (e, fact) =>
      @lastChannelStatus =
        view: @channel_views.currentView()
        scrollTop: $('body').scrollTop()

      navigate_to = baseUrl + "/facts/" + fact.id
      Backbone.history.navigate navigate_to, true
      $('body').scrollTo(0)

      e.preventDefault()
      e.stopPropagation()
