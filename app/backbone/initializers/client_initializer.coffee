componentKey = 0
getComponentKey = -> componentKey++

showInSidebar = (elements...)->
  component = ReactDiscussionSidebarContainer({}, elements...)
  el = document.querySelector('.js-discussion-sidebar-region')
  React.renderComponent(component, el)

class ClientEnvoy
  constructor: (senderEnvoy) ->
    @_senderEnvoy = senderEnvoy

  showFactlink: (fact_id, site_url) ->
    Factlink.load_client_dependencies()

    fact = new Fact id: fact_id
    fact.fetch()
    @_senderEnvoy 'highlightExistingFactlink', fact.id

    showInSidebar ReactDiscussionSidebar
      model: fact
      initiallyFocusAddComment: true
      key: getComponentKey()
      site_url: site_url

  prepareNewFactlink: (displaystring, site_url, site_title) =>
    Factlink.load_client_dependencies()

    fact = new Fact
      displaystring: displaystring
      site_url: site_url
      site_title: site_title

    fact.once 'sync', =>
      @_senderEnvoy 'highlightNewFactlink', displaystring, fact.id

    showInSidebar ReactDiscussionSidebar
      model: fact
      initiallyFocusAddComment: true
      key: getComponentKey()
      site_url: site_url

printDevelopmentHelp = ->
  return unless Factlink.Global.environment == 'development'

  console.group 'Factlink'
  console.log 'Greetings, stranger. Put any of the following commands in your console:'
  console.log '  clientEnvoy.showFactlink(3, "http://example.org/")'
  console.log '  clientEnvoy.prepareNewFactlink("Hello World", "http://example.org/", "Example")'
  console.log 'Or put one of these commands in your hash (and reload):'
  console.log '  localhost:3000/client/blank#clientEnvoy.showFactlink(3, "http://example.org/")'
  console.log '  localhost:3000/client/blank#clientEnvoy.prepareNewFactlink("Hello World", "http://example.org/", "Example")'
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

Factlink.clientInitializer = ->
  Factlink.commonInitializer()
  showInSidebar()

  window.Factlink.notificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new window.NonConfirmedEmailWarning()

  Factlink.vent.on 'close_discussion_sidebar', ->
    console.info 'closing modal'

    showInSidebar()

    callback = -> senderEnvoy 'closeModal'
    _.delay callback, discussion_sidebar_slide_transition_duration

  window.addEventListener 'keydown', (e) ->
    if e.keyCode == 27
      e.preventDefault()
      e.stopPropagation()
      Factlink.vent.trigger 'close_discussion_sidebar'

  if window.parent && window != window.parent
    senderEnvoy = Factlink.createSenderEnvoy(window.parent)
    Factlink.createReceiverEnvoy new ClientEnvoy(senderEnvoy)
  else
    senderEnvoy = (args...) ->
      if Factlink.Global.environment == 'development'
        console.info 'senderEnvoy:', args...
    initDevelopmentConsole new ClientEnvoy(senderEnvoy)

  senderEnvoy 'modalFrameReady'
