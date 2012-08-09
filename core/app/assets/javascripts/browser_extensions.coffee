detectChromeExtension = (options)->
  s = document.createElement("script")
  s.onerror = options.error
  s.onload = options.success
  document.body.appendChild s
  s.src = "chrome-extension://#{options.id}/manifest.json"

checkChromeExtensionByIds = (ids, found, notFound)->
  if ids.length == 0
    notFound()
  else
    detectChromeExtension(
      id: _.first(ids)
      success: -> found()
      error: -> checkChromeExtensionByIds(_.tail(ids), found, notFound)
    )

if Backbone.Factlink.Global.chrome_extension_ids
  is_chrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
  if is_chrome
    $("html").addClass "is-chrome"

    checkChromeExtensionByIds(Backbone.Factlink.Global.chrome_extension_ids,
        -> $("html").addClass "chrome_extension_installed",
        -> $("html").addClass "chrome_extension_not_installed"
      )
  else
    $("html").addClass "no-chrome"
