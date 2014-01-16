class window.ChannelsController extends Backbone.Marionette.Controller
  constructor: (@options) ->

  showStream: ->
    FactlinkApp.mainRegion.show new FeedActivitiesView
      collection: new FeedActivities

    mp_track 'Viewed feed'

  showFact: (fact_id, params={})->
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
