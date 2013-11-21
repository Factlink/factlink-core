class window.ChannelsController extends Backbone.Marionette.Controller

  loadTopic: (slug_title, callback) ->
    topic = new Topic {slug_title}
    topic.fetch success: (model) -> callback(model)
    topic

  showSidebarForTopic: (topic) ->
    FactlinkApp.leftBottomRegion.close()

    if Factlink.Global.signed_in
      @showUserProfile currentUser
      window.Channels.setUsernameAndRefreshIfNeeded currentUser.get('username') # TODO: check if this can be removed
      FactlinkApp.Sidebar.showForTopicsAndActivateCorrectItem(topic)

  showTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.close()

    @loadTopic slug_title, (topic) =>
      @showSidebarForTopic(topic)
      FactlinkApp.mainRegion.show new TopicView model: topic


  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id)

    if (channel)
      callback(channel)
    else
      channel = new Channel created_by: {username: username}, id: channel_id
      channel.fetch
        success: -> callback(channel)

    channel

  showSidebarForChannel: (channel) ->
    user = channel.user()
    @showUserProfile user
    window.Channels.setUsernameAndRefreshIfNeeded user.get('username') # TODO: check if this can be removed
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem window.Channels, channel, user

  showUserProfile: (user)->
    if user.is_current_user()
      FactlinkApp.leftTopRegion.close()
    else
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)

  showChannelFacts: (username, channel_id) ->
    FactlinkApp.mainRegion.close()

    @loadChannel username, channel_id, (channel) =>
      @showSidebarForChannel(channel)
      FactlinkApp.mainRegion.show new ChannelView(model: channel)

  showStream: ->
    FactlinkApp.leftTopRegion.close()
    FactlinkApp.mainRegion.close()

    @showSidebarForTopic(null)
    FactlinkApp.Sidebar.activate('stream')
    activities = new FeedActivities
    FactlinkApp.mainRegion.show new FeedActivitiesView(collection: activities)


  showFact: (slug, fact_id, params={})->
    fact = new Fact id: fact_id

    fact.fetch
      success: =>
        FactlinkApp.DiscussionModalOnFrontend.openDiscussion fact
        @_showBackgroundForFact fact

  _showBackgroundForFact: (fact) ->
    return if FactlinkApp.mainRegion.currentView?

    if Factlink.Global.signed_in
      @showStream()
      url = Backbone.history.getFragment currentUser.streamLink()
    else
      user = fact.user()
      FactlinkApp.ProfileController.showProfile user.get('username')
      url = user.link()

    FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlFromShowFact url
