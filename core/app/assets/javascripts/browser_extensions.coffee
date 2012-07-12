detectChromeExtension = ->
  s = document.createElement("script")
  s.onerror = -> $("html").addClass "chrome_without_extension"
  s.onload = -> $("html").addClass "chrome_extension_installed"
  document.body.appendChild s
  s.src = "chrome-extension://#{Backbone.Factlink.Global.chrome_extension_id}/manifest.json"

if Backbone.Factlink.Global.chrome_extension_id
  is_chrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
  if is_chrome
    $("html").addClass "is-chrome"
    detectChromeExtension()
  else
    $("html").addClass "no-chrome"