class window.ChannelsController extends Backbone.Factlink.BaseController

  routes: ['getChannelFacts', 'getChannelFact', 'getChannelActivities', 'getChannelFactForActivity', 'getTopicFacts', 'getTopicFact']

  onShow:   -> @channel_views = new Backbone.Factlink.DetachedViewCache
  onClose:  -> @channel_views.cleanup()
  onAction: -> @unbindFrom @permalink_event if @permalink_event?

  loadTopic: (slug_title, callback) ->
    topic = new Topic {slug_title}
    topic.fetch success: (model) -> callback(model)
    topic

  restoreTopicView: (slug_title, new_callback) ->
    @restoreChannelView "topic-#{slug_title}", new_callback

  showSidebarForTopic: (topic) ->
    FactlinkApp.leftBottomRegion.close()
    @showUserProfile currentUser
    FactlinkApp.Sidebar.showForTopicsAndActivateCorrectItem(topic, currentUser)

  getTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.show(@channel_views)

    @loadTopic slug_title, (topic) =>
      @showSidebarForTopic(topic)
      @restoreTopicView slug_title, => new TopicView model: topic
      @makePermalinkEvent(topic.url())

  getTopicFact: (slug_title, fact_id, params={}) ->
    topic = @loadTopic slug_title,
      => @showSidebarForTopic topic
    back_button = new TopicBackButton [], model: topic

    FactlinkApp.mainRegion.show new DiscussionPageView
      model: new Fact(id: fact_id)
      back_button: back_button
      tab: params.tab

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id)

    mp_track("mp_page_view", {mp_page: window.location.href})

    if (channel)
      callback(channel)
    else
      channel = new Channel created_by: {username: username}, id: channel_id
      channel.fetch
        success: -> callback(channel)

    channel

  showSidebarForChannel: (channel) ->
    @showRelatedChannels channel
    @showUserProfile channel.user()
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem window.Channels, channel, channel.user()

  showRelatedChannels: (channel)->
    if channel.get('is_normal')
      FactlinkApp.leftBottomRegion.show(new RelatedChannelsView(model: channel))
    else
      FactlinkApp.leftBottomRegion.close()

  showUserProfile: (user)->
    if user.is_current_user()
      FactlinkApp.leftTopRegion.close()
    else
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)

  getChannelFacts: (username, channel_id) ->
    FactlinkApp.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @showSidebarForChannel(channel)
      @makePermalinkEvent(channel.url())

      @restoreChannelView channel_id, => new ChannelView(model: channel)

  # TODO: this is only ever used for the stream,
  #       don't act like this is a general function
  getChannelActivities: (username, channel_id) ->
    # getStream
    FactlinkApp.leftTopRegion.close()

    FactlinkApp.mainRegion.show(@channel_views)

    @loadChannel username, channel_id, (channel) =>
      @showSidebarForChannel(channel)
      FactlinkApp.Sidebar.activate('stream')
      @makePermalinkEvent(channel.url() + '/activities')

      @restoreChannelView channel_id, =>
        activities = new ChannelActivities([],{ channel: channel })
        new ChannelActivitiesView(model: channel, collection: activities)

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, for_stream: true)

  getChannelFact: (username, channel_id, fact_id, params={}) ->
    channel = @loadChannel username, channel_id, (channel) => @showSidebarForChannel channel
    back_button = new ChannelBackButton [], model: channel, for_stream: params.for_stream

    FactlinkApp.mainRegion.show new DiscussionPageView
      model: new Fact(id: fact_id)
      back_button: back_button
      tab: params.tab

  restoreChannelView: (channel_id, new_callback) ->
    if @lastChannelStatus?
      view = @channel_views.switchCacheView(channel_id)
      $('body').scrollTo(@lastChannelStatus.scrollTop) if view == @lastChannelStatus?.view
      delete @lastChannelStatus

    @channel_views.clearUnshowedViews()

    @channel_views.renderCacheView(channel_id, new_callback()) if not view?

  makePermalinkEvent: (baseUrl) ->
    FactlinkApp.factlinkBaseUrl = baseUrl
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', =>
      @lastChannelStatus =
        view: @channel_views.currentView()
        scrollTop: $('body').scrollTop()
      $('body').scrollTo(0)
