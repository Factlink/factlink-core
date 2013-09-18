window.FACTLINK_START_LOADER = ->
  if window.FACTLINK_LOADED
    console.error 'FACTLINK already loaded!'
    return
  window.FACTLINK_LOADED = true

  #### Create iframe
  iframe = document.createElement('iframe')
  iframe.style.display = 'block'
  iframe.style.border = '0px solid transparent'
  iframe.id = 'factlink-iframe'

  # Wrappers for increased CSS specificity
  div = document.createElement('div')
  wrapper1 = document.createElement('div')
  wrapper2 = document.createElement('div')
  wrapper3 = document.createElement('div')

  # Keep in sync with #fl-wrapper-1 in basic.less
  wrapper1.style.visibility = 'hidden'; # Prevent showing stuff when css is not loaded yet
  wrapper1.style.position = 'absolute'; # Prevent reflowing of the page

  wrapper1.id = 'fl-wrapper-1'
  wrapper2.id = 'fl-wrapper-2'
  wrapper3.id = 'fl-wrapper-3'
  div.id = 'fl'

  wrapper1.appendChild wrapper2
  wrapper2.appendChild wrapper3
  wrapper3.appendChild div
  document.body.appendChild wrapper1

  div.insertBefore iframe, div.firstChild

  #### Create <script> tag

  coreScriptTag = document.createElement('script')

  hashOfFactlinkCoreFile = '&*HASH_PLACE_HOLDER*&' # Overwritten by grunt task
  if window.FactlinkConfig.srcPath.match(/\.min\.js$/)
    if hashOfFactlinkCoreFile is '&*HASH_PLACE_HOLDER*&'
      hashOfFactlinkCoreFile = ''
    else
      hashOfFactlinkCoreFile = '.' + hashOfFactlinkCoreFile
    coreScriptTag.src = window.FactlinkConfig.lib + '/factlink.core.min' + hashOfFactlinkCoreFile + '.js'
  else
    coreScriptTag.src = window.FactlinkConfig.lib + window.FactlinkConfig.srcPath

  #### Create proxy object that stores all calls

  window.FACTLINK = {}

  storedMethodCalls = []
  proxy_method = (name) ->
    window.FACTLINK[name] = ->
      if iframe.contentWindow.Factlink?
        iframe.contentWindow.Factlink[name](arguments...)
        return # don't return the value, as we also don't do that when storing calls
      else
        storedMethodCalls.push {name: name, arguments: arguments}
        return

  proxy_method 'on'
  proxy_method 'triggerClick'
  proxy_method 'startHighlighting'
  proxy_method 'stopHighlighting'
  proxy_method 'startAnnotating'
  proxy_method 'stopAnnotating'
  proxy_method 'showLoadedNotification'

  window.FACTLINK_ON_CORE_LOAD = ->
    # This seems to be necessary, don't understand entirely why
    window.FACTLINK.easyXDM = iframe.contentWindow.Factlink.easyXDM

    for methodCall in storedMethodCalls
      iframe.contentWindow.Factlink[methodCall.name](methodCall.arguments...)
    storedMethodCalls = []

  #### Load iframe with script tag

  window.FACTLINK_ON_IFRAME_LOAD = ->
    iframe.contentWindow.document.head.appendChild coreScriptTag

  iframeDoc = iframe.contentWindow.document
  iframeDoc.open()
  iframeDoc.write """
    <!DOCTYPE html><html><head>
      <script>
        window.FactlinkConfig = #{JSON.stringify(window.FactlinkConfig)};
        window.parent.FACTLINK_ON_IFRAME_LOAD();
      </script>
    </head><body></body></html>
  """
  iframeDoc.close()
