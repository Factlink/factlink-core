unless $('html').hasClass('chrome_extension_installed')
  detectChromeExtension = ->
    s = document.createElement("script")
    s.onerror = -> $("html").addClass "chrome_extension_not_installed"
    s.onload = -> $("html").addClass "chrome_extension_installed"
    document.body.appendChild s
    s.src = "chrome-extension://#{Factlink.Global.chrome_extension_id}/manifest.json"

  if Factlink.Global.chrome_extension_id
    is_chrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
    if is_chrome
      detectChromeExtension()
