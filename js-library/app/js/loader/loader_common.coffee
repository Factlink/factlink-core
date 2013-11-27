mkEl = (name) -> (id, domContent) ->
  wrapper = document.createElement(name)
  id && wrapper.id = id
  wrapper.appendChild(domContent)
  wrapper

mkDiv = mkEl 'div'

window.FACTLINK_START_LOADER = ->
  if window.FACTLINK_LOADED
    console.error 'FACTLINK already loaded!'
    return
  window.FACTLINK_LOADED = true

  #### Create iframe so jslib's namespace (window) doesn't collide with any content window.
  jslib_jail_iframe = document.createElement('iframe')
  jslib_jail_iframe.style.display = 'block'
  jslib_jail_iframe.style.border = '0px solid transparent'
  jslib_jail_iframe.id = 'factlink-iframe'

  # Wrappers for increased CSS specificity
  outerWrapperEl =
    mkDiv 'fl-wrapper-1',
      mkDiv 'fl-wrapper-2',
        mkDiv 'fl-wrapper-3',
          mkDiv 'fl', jslib_jail_iframe

  # Keep in sync with #fl-wrapper-1 in basic.less
  outerWrapperEl.style.visibility = 'hidden'; # Prevent showing stuff when css is not loaded yet
  outerWrapperEl.style.position = 'absolute'; # Prevent reflowing of the page

  document.body.appendChild outerWrapperEl

  # Create proxy object that stores all calls
  # proxies calls from external content page to the js-library "jail" iframe's "Factlink"..
  window.FACTLINK = {}

  storedMethodCalls = []
  proxy_method = (name) ->
    window.FACTLINK[name] = ->
      if jslib_jail_iframe.contentWindow.Factlink?
        jslib_jail_iframe.contentWindow.Factlink[name](arguments...)
        return # don't return the value, as we also don't do that when storing calls
      else
        storedMethodCalls.push {name: name, arguments: arguments}
        return

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
    # This seems to be necessary, don't understand entirely why
    window.FACTLINK.easyXDM = jslib_jail_iframe.contentWindow.Factlink.easyXDM

    for methodCall in storedMethodCalls
      jslib_jail_iframe.contentWindow.Factlink[methodCall.name](methodCall.arguments...)
    storedMethodCalls = []

  #### Load iframe with script tag
  jslib_jail_doc = jslib_jail_iframe.contentWindow.document

  jslib_jail_doc.open()
  jslib_jail_doc.write """<!DOCTYPE html><title></title>"""
  jslib_jail_doc.close()

  script_tag = jslib_jail_doc.createElement 'script'
  script_tag.appendChild(
    jslib_jail_doc.createTextNode("""window.FactlinkConfig = #{JSON.stringify(window.FactlinkConfig)};

#{jslib_jail_code};

window.parent.FACTLINK_ON_CORE_LOAD();
"""))
  jslib_jail_doc.documentElement.appendChild(script_tag)

  style_tag = (mkEl 'style') null, document.createTextNode(style_code)
  document.getElementsByTagName('head')[0].appendChild style_tag

jslib_jail_code = __INLINE_JS_PLACEHOLDER__
style_code = __INLINE_CSS_PLACEHOLDER__


