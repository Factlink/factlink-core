mkEl = (name, id, content) ->
  el = document.createElement(name)
  id && el.id = id
  content && el.appendChild(content)
  el

window.FACTLINK_START_LOADER = ->
  if window.FACTLINK_LOADED
    console.error 'FACTLINK already loaded!'
    return
  window.FACTLINK_LOADED = true

  # Add styles
  style_tag = mkEl 'style', null, document.createTextNode(style_code)
  document.getElementsByTagName('head')[0].appendChild style_tag

  #### Create iframe so jslib's namespace (window) doesn't collide with any content window.
  jslib_jail_iframe = mkEl 'iframe', 'factlink-iframe'

  # Wrappers for increased CSS specificity
  outerWrapperEl =
    mkEl 'div', 'fl-wrapper-1',
      mkEl 'div', 'fl-wrapper-2',
        mkEl 'div', 'fl-wrapper-3',
          mkEl 'div', 'fl', jslib_jail_iframe

  document.body.appendChild outerWrapperEl

  # Create proxy object that stores all calls
  # proxies calls from external content page to the js-library "jail" iframe's "FactlinkJailRoot"..
  window.FACTLINK = {}

  storedMethodCalls = []
  proxy_method = (name) ->
    window.FACTLINK[name] = ->
      if window.FACTLINK_ON_CORE_LOAD
        storedMethodCalls.push {name: name, arguments: arguments}
      else
        jail_window.FactlinkJailRoot[name](arguments...)
      return # don't return the value, as we can't do that when storing calls

  proxy_method 'on'
  proxy_method 'triggerClick'
  proxy_method 'startHighlighting'
  proxy_method 'highlightAdditionalFactlinks'
  proxy_method 'startAnnotating'
  proxy_method 'stopAnnotating'
  proxy_method 'showLoadedNotification'
  proxy_method 'scrollTo'
  proxy_method 'openFactlinkModal'
  proxy_method 'initializeFactlinkButton'

  window.FACTLINK_ON_CORE_LOAD = ->
    delete window.FACTLINK_ON_CORE_LOAD
    for methodCall in storedMethodCalls
      jail_window.FactlinkJailRoot[methodCall.name](methodCall.arguments...)
    storedMethodCalls = undefined

  jail_window = jslib_jail_iframe.contentWindow
  jail_window.FactlinkConfig = window.FactlinkConfig
  #### Load iframe with script tag
  jslib_jail_doc = jail_window.document

  jslib_jail_doc.open()
  jslib_jail_doc.write '<!DOCTYPE html><title></title>'
  jslib_jail_doc.close()

  script_tag = jslib_jail_doc.createElement 'script'
  script_tag.appendChild(jslib_jail_doc.createTextNode(jslib_jail_code))
  jslib_jail_doc.documentElement.appendChild(script_tag)


jslib_jail_code = __INLINE_JS_PLACEHOLDER__
style_code = __INLINE_CSS_PLACEHOLDER__


