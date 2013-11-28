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
  jslib_jail_iframe.style.display = 'block'
  jslib_jail_iframe.style.border = '0px solid transparent'

  # Wrappers for increased CSS specificity
  outerWrapperEl =
    mkEl 'div', 'fl-wrapper-1',
      mkEl 'div', 'fl-wrapper-2',
        mkEl 'div', 'fl-wrapper-3',
          mkEl 'div', 'fl', jslib_jail_iframe

  document.body.appendChild outerWrapperEl

  # Create proxy object that stores all calls
  # proxies calls from external content page to the js-library "jail" iframe's "Factlink"..
  window.FACTLINK = {}

  storedMethodCalls = []
  proxy_method = (name) ->
    window.FACTLINK[name] = ->
      if jslib_jail_iframe.contentWindow.Factlink?
        jslib_jail_iframe.contentWindow.Factlink[name](arguments...)
      else
        storedMethodCalls.push {name: name, arguments: arguments}
      return # don't return the value, as we can't do that when storing calls

  proxy_method 'on'
  proxy_method 'triggerClick'
  proxy_method 'startHighlighting'
  proxy_method 'highlightAdditionalFactlinks'
  proxy_method 'stopHighlighting'
  proxy_method 'startAnnotating'
  proxy_method 'stopAnnotating'
  proxy_method 'showLoadedNotification'
  proxy_method 'scrollTo'
  proxy_method 'openFactlinkModal'
  proxy_method 'initializeFactlinkButton'

  window.FACTLINK_ON_CORE_LOAD = ->
    for methodCall in storedMethodCalls
      jslib_jail_iframe.contentWindow.Factlink[methodCall.name](methodCall.arguments...)
    storedMethodCalls = []

  jslib_jail_iframe.contentWindow.FactlinkConfig = window.FactlinkConfig
  #### Load iframe with script tag
  jslib_jail_doc = jslib_jail_iframe.contentWindow.document

  jslib_jail_doc.open()
  jslib_jail_doc.write """<!DOCTYPE html><title></title>"""
  jslib_jail_doc.close()

  script_tag = jslib_jail_doc.createElement 'script'
  script_tag.appendChild(
    jslib_jail_doc.createTextNode(
      "#{jslib_jail_code};window.parent.FACTLINK_ON_CORE_LOAD();"))
  jslib_jail_doc.documentElement.appendChild(script_tag)


jslib_jail_code = __INLINE_JS_PLACEHOLDER__
style_code = __INLINE_CSS_PLACEHOLDER__


