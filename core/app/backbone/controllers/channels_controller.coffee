class window.ChannelsController extends Backbone.Marionette.Controller
  constructor: (@options) ->
  loadTopic: (slug_title, callback) ->
    topic = new Topic {slug_title}
    topic.fetch success: (model) -> callback(model)
    topic

  showTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.close()

    @loadTopic slug_title, (topic) =>
      FactlinkApp.mainRegion.show new TopicView model: topic

  showStream: ->
    FactlinkApp.mainRegion.close()

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
