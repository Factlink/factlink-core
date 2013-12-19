unsupported_browser = document.documentMode < 9

window.FACTLINK = {}
# Create proxy object that stores all calls
# proxies calls from external content page to the js-library "jail" iframe's "FactlinkJailRoot"..
methods = 'on,triggerClick,startHighlighting,highlightAdditionalFactlinks,startAnnotating,stopAnnotating,showLoadedNotification,scrollTo,openFactlinkModal,initializeFactlinkButton'.split(',')

storedMethodCalls = []

for name in methods
  do (name) ->
    window.FACTLINK[name] =
      if unsupported_browser
        ->
      else
        ->
          storedMethodCalls.push {name: name, arguments: arguments}
          return

window.FACTLINK_START_LOADER = ->
  return if unsupported_browser
  if window.FACTLINK_LOADED
    console.error 'FACTLINK already loaded!'
    return
  window.FACTLINK_LOADED = true

  mkEl = (name, id, content) ->
    el = document.createElement(name)
    id && el.id = id
    content && el.appendChild(content)
    el

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

  window.FACTLINK_ON_CORE_LOAD = ->
    for name in methods
      do (name) ->
        # don't return the value, as we can't do that when storing calls
        window.FACTLINK[name] = ->
          jslib_jail_iframe.contentWindow.FactlinkJailRoot[name](arguments...)
          return

    delete window.FACTLINK_ON_CORE_LOAD

    for methodCall in storedMethodCalls
      window.FACTLINK[methodCall.name](methodCall.arguments...)
    storedMethodCalls = undefined

  jslib_jail_iframe.contentWindow.FactlinkConfig = window.FactlinkConfig
  #### Load iframe with script tag
  jslib_jail_doc = jslib_jail_iframe.contentWindow.document

  jslib_jail_doc.open()
  jslib_jail_doc.write """<!DOCTYPE html><title></title>"""
  jslib_jail_doc.close()

  script_tag = jslib_jail_doc.createElement 'script'
  script_tag.appendChild(jslib_jail_doc.createTextNode(jslib_jail_code))
  jslib_jail_doc.documentElement.appendChild(script_tag)


jslib_jail_code = __INLINE_JS_PLACEHOLDER__
style_code = __INLINE_CSS_PLACEHOLDER__


