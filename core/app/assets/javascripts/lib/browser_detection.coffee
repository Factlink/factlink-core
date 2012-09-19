window.detectBrowser = ->

  matched = undefined
  userAgent = navigator.userAgent or ""

  jQuery.uaMatch = (ua) ->
    ua = ua.toLowerCase()
    match = /(chrome)[ \/]([\w.]+)/.exec(ua) or /(webkit)[ \/]([\w.]+)/.exec(ua) or /(opera)(?:.*version)?[ \/]([\w.]+)/.exec(ua) or /(msie) ([\w.]+)/.exec(ua) or ua.indexOf("compatible") < 0 and /(mozilla)(?:.*? rv:([\w.]+))?/.exec(ua) or []
    browser: match[1] or ""
    version: match[2] or "0"

  matched = jQuery.uaMatch(userAgent)
  jQuery.browser = {}

  if matched.browser
    jQuery.browser[matched.browser] = true
    jQuery.browser.version = matched.version
  jQuery.browser.safari = true  if jQuery.browser.webkit

  return matched


browser = switch detectBrowser().browser
  when "chrome"  then "chrome"
  when "mozilla" then "firefox"
  else "unsupported-browser"


$('html').addClass(browser)
