class window.ChannelsController extends Backbone.Factlink.BaseController

  routes: ['getChannelFacts', 'getChannelFact', 'getChannelActivities', 'getChannelFactForActivity', 'getTopicFacts']

  onShow:   -> @channel_views = new Backbone.Factlink.DetachedViewCache
  onClose:  -> @channel_views.cleanup()
  onAction: -> @unbindFrom @permalink_event if @permalink_event?

  # <topics>
  # TODO: refactor until we don't refer to channels any more
  loadTopic: (slug_title, callback) ->
    topic = new Topic {slug_title}
    topic.fetch success: (model) -> callback(model)

  restoreTopicView: (slug_title, new_callback) ->
    @restoreChannelView "topic-#{slug_title}", new_callback

  commonTopicViews: (topic) ->
    channel = topic.existingChannelFor(currentUser)
    window.currentChannel = channel

    FactlinkApp.leftBottomRegion.close()
    @showChannelSideBar(window.Channels, channel, currentUser)
    @showUserProfile currentUser

  getTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.show(@channel_views)

    @loadTopic slug_title, (topic) =>
      window.currentUser.channels.waitForFetch =>
        @commonTopicViews(topic)
        @restoreTopicView slug_title, => new TopicView model: topic

        # TODO topic permalink
        channel = topic.existingChannelFor(window.currentUser)
        @makePermalinkEvent(channel.url())
  # </topics>

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id)

    mp_track("mp_page_view", {mp_page: window.location.href})

    withChannel = (channel) ->
      channel.set
        new_facts: false
        unread_count: 0

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
      FactlinkApp.leftBottomRegion.show(new RelatedChannelsView(model: channel))
    else
      FactlinkApp.leftBottomRegion.close()

  showChannelSideBar: (channels, currentChannel, user)->
    window.Channels.setUsernameAndRefreshIfNeeded(user.get('username'))
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
    FactlinkApp.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      @makePermalinkEvent(channel.url())

      @restoreChannelView channel_id, => new ChannelView(model: channel)

  getChannelActivities: (username, channel_id) ->
    FactlinkApp.leftTopRegion.close()

    FactlinkApp.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @commonChannelViews(channel)
      @makePermalinkEvent(channel.url() + '/activities')

      @restoreChannelView channel_id, =>
        activities = new ChannelActivities([],{ channel: channel })
        new ChannelActivitiesView(model: channel, collection: activities)

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, for_stream: true)

  getChannelFact: (username, channel_id, fact_id, params={}) ->
    @main = new TabbedMainRegionLayout();
    FactlinkApp.mainRegion.show(@main)

    channel = `undefined`
    fact = `undefined`

    with_both = =>
      return_to_url = channel.url()
      return_to_url = return_to_url + "/activities" if params.for_stream

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
        dv = new DiscussionView(model: model, tab: params.tab)
        @main.contentRegion.show(dv)
        callback_with_both()
      error: => FactlinkApp.NotificationCenter.error("This Factlink could not be found. <a onclick='history.go(-1);$(this).closest(\"div.alert\").remove();'>Click here to go back.</a>")

  restoreChannelView: (channel_id, new_callback) ->
    if @lastChannelStatus?
      view = @channel_views.switchCacheView(channel_id)
      $('body').scrollTo(@lastChannelStatus.scrollTop) if view == @lastChannelStatus?.view
      delete @lastChannelStatus

    @channel_views.clearUnshowedViews()

    @channel_views.renderCacheView(channel_id, new_callback()) if not view?

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
