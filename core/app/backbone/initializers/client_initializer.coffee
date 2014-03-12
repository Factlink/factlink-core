class ClientEnvoy
  constructor: (senderEnvoy) ->
    @_senderEnvoy = senderEnvoy

  showFactlink: (fact_id) ->
    fact = new Fact id: fact_id
    fact.fetch()
    @_senderEnvoy 'highlightExistingFactlink', fact.id

    FactlinkApp.discussionSidebarContainer.slideIn new ReactView
      component: ReactDiscussion
        model: fact
        initiallyFocusAddComment: true

  prepareNewFactlink: (displaystring, url, site_title) =>
    fact = new Fact
      displaystring: displaystring
      url: url
      site_title: site_title

    fact.once 'sync', =>
      @_senderEnvoy 'highlightNewFactlink', displaystring, fact.id
      mp_track 'Factlink: Created'

    FactlinkApp.discussionSidebarContainer.slideIn new ReactView
      component: ReactDiscussion
        model: fact
        initiallyFocusAddComment: true


printDevelopmentHelp = ->
  return unless Factlink.Global.environment == 'development'

  console.group 'Factlink'
  console.log 'Greetings, stranger. Put any of the following commands in your console:'
  console.log '  clientEnvoy.showFactlink(3)'
  console.log '  clientEnvoy.prepareNewFactlink("Hello World", "http://example.org", "Example")'
  console.log 'Or put one of these commands in your hash (and reload):'
  console.log '  localhost:3000/client/blank#clientEnvoy.showFactlink(3)'
  console.log '  localhost:3000/client/blank#clientEnvoy.prepareNewFactlink("Hello World", "http://example.org", "Example")'
  console.log 'Now, how about a nice game of chess?'
  console.groupEnd()

initDevelopmentConsole = (clientEnvoy) ->
  return unless Factlink.Global.environment in ['development', 'test']

  printDevelopmentHelp()
  window.clientEnvoy = clientEnvoy

  command = window.location.hash.substring(1)
  if command.match /^clientEnvoy/
    console.info 'Executing: ', command
    eval(command)

window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInClient = (app) ->
  app.startClientRegions()

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

  if window.parent && window != window.parent
    senderEnvoy = Factlink.createSenderEnvoy(window.parent)
    Factlink.createReceiverEnvoy new ClientEnvoy(senderEnvoy)
  else
    senderEnvoy = (args...) -> console.info 'senderEnvoy:', args...
    initDevelopmentConsole new ClientEnvoy(senderEnvoy)

  senderEnvoy 'modalFrameReady'
