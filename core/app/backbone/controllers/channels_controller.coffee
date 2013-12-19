class window.ChannelsController extends Backbone.Marionette.Controller
  constructor: (@options) ->
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
    else
      @hideUserProfile()

  showTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.close()

    @loadTopic slug_title, (topic) =>
      @showSidebarForTopic(topic)
      FactlinkApp.mainRegion.show new TopicView model: topic

  showUserProfile: (user)->
    if user.is_current_user()
      @hideUserProfile()
    else
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)

  hideUserProfile: ->
    FactlinkApp.leftTopRegion.close()

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
      @options.showProfile user.get('username')
      url = user.link()

    FactlinkApp.DiscussionModalOnFrontend.setBackgroundPageUrlFromShowFact url
