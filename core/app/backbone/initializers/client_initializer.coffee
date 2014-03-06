class ClientController
  constructor: (senderEnvoy) ->
    @_senderEnvoy = senderEnvoy

  showFactlink: (fact_id) ->
    @_renderDiscussion new Fact id: fact_id

  prepareNewFactlink: (displaystring, url, site_title) =>
    fact = new Fact
      displaystring: displaystring
      url: url
      site_title: site_title

    fact.save {},
      success: =>
        @_senderEnvoy 'highlightNewFactlink', displaystring, fact.id

        @_renderDiscussion fact
        Backbone.history.navigate "/client/facts/#{fact.id}", trigger: false
        mp_track 'Factlink: Created'

  _renderDiscussion: (fact) ->
    @_senderEnvoy 'highlightExistingFactlink', fact.id
    fact.fetch()

    FactlinkApp.discussionSidebarContainer.slideIn new ReactView
      component: ReactDiscussion
        model: fact
        initiallyFocusAddComment: true


window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.startClientRegions()

  if window.parent && window != window.parent
    senderEnvoy = Factlink.createSenderEnvoy(window.parent)
    Factlink.createReceiverEnvoy new ClientController(senderEnvoy)
  else
    senderEnvoy = ->

  FactlinkApp.discussionSidebarContainer = new DiscussionSidebarContainer
  FactlinkApp.discussionSidebarRegion.show FactlinkApp.discussionSidebarContainer

  app.vent.on 'close_discussion_sidebar', ->
    mp_track "Discussion Sidebar: Close (Button)"

    FactlinkApp.discussionSidebarContainer.slideOut ->
      senderEnvoy 'closeModal'

  window.addEventListener 'keydown', (e) ->
    if e.keyCode == 27
      e.preventDefault()
      e.stopPropagation()
      app.vent.trigger 'close_discussion_sidebar'

  senderEnvoy 'modalFrameReady'
