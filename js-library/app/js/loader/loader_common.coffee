factlink_loader_start_timestamp = new Date().getTime()

window.FACTLINK_START_LOADER = ->
  unsupported_browser = document.documentMode < 9
  return if unsupported_browser
  if window.FACTLINK_LOADED
    console.error 'FACTLINK already loaded!'
    return
  window.FACTLINK_LOADED = true

  window.FACTLINK = {}

  # Create proxy object that stores all calls
  # proxies calls from external content page to the js-library "jail" iframe's "FactlinkJailRoot"..
  methods = 'on,triggerClick,highlightAdditionalFactlinks,startAnnotating,stopAnnotating,showLoadedNotification,scrollTo,openFactlinkModal,initializeFactlinkButton,showProxyMessage'.split(',')

  storedMethodCalls = []

  storedMethodFactory = (name) ->
    -> storedMethodCalls.push(name: name, arguments: arguments) && undefined

  for name in methods
    window.FACTLINK[name] =
      if unsupported_browser
        ->
      else
        storedMethodFactory name

  mkEl = (name, id, content) ->
    el = document.createElement(name)
    id && el.id = id
    content && el.appendChild(content)
    el

  whenHasBody = ->
    # Add styles
    style_tag = mkEl 'style', null, document.createTextNode(style_code)
    document.getElementsByTagName('head')[0].appendChild style_tag

    #### Create iframe so jslib's namespace (window) doesn't collide with any content window.
    jslib_jail_iframe = mkEl 'iframe', 'factlink-iframe'

    # Wrapper for increased CSS specificity
    outerWrapperEl = mkEl 'div', 'factlink-containment-wrapper', jslib_jail_iframe

    document.body.insertBefore(outerWrapperEl, document.body.firstChild)

    load_time_before_jail = new Date().getTime()

    jail_window = jslib_jail_iframe.contentWindow
    jail_window.FactlinkConfig = window.FactlinkConfig
    jail_window.FrameCss = frame_style_code

    #### Load iframe with script tag
    jslib_jail_doc = jail_window.document

    jslib_jail_doc.open()
    jslib_jail_doc.write '<!DOCTYPE html><title></title>'
    jslib_jail_doc.close()

    script_tag = jslib_jail_doc.createElement 'script'
    script_tag.appendChild(jslib_jail_doc.createTextNode(jslib_jail_code))
    jslib_jail_doc.documentElement.appendChild(script_tag)

    root = jslib_jail_iframe.contentWindow.FactlinkJailRoot
    $ = jslib_jail_iframe.contentWindow.$
    root.perf.add_existing_timing_event 'factlink_loader_start', factlink_loader_start_timestamp
    root.perf.add_existing_timing_event 'before_jail', load_time_before_jail
    root.perf.add_timing_event 'after_jail'

    root.initializers.forEach( (f) -> f())

    root.core_loaded_promise
    .then( ->
        root.perf.add_timing_event 'core_loaded'
    )
    .then ->
      #called from jail-iframe when core iframe is ready.
      for name in methods
        do (name) ->
          # don't return the value, as we can't do that when storing calls
          window.FACTLINK[name] = ->
            jslib_jail_iframe.contentWindow.FactlinkJailRoot[name](arguments...)
            return

      for methodCall in storedMethodCalls
        window.FACTLINK[methodCall.name](methodCall.arguments...)
      storedMethodCalls = undefined
      root.perf.add_timing_event 'FACTLINK_queue_emptied'


  tryToInit = (i) -> ->
    if document.body
      whenHasBody()
    else
      setTimeout tryToInit(i+1), i

  tryToInit(1)()

jslib_jail_code = __INLINE_JS_PLACEHOLDER__
style_code = __INLINE_CSS_PLACEHOLDER__
frame_style_code = __INLINE_FRAME_CSS_PLACEHOLDER__


