showPopup = (url) ->
  width  = 640
  height = 400
  left   = (screen.width/2)-(width/2)
  top    = (screen.height/2)-(height/2)
  window.open url, "authPopup",
    "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},left=#{left},top=#{top}"

$('html').on 'click', '.js-social-popup-link', (e) ->
  showPopup($(e.target).attr("href"))
  e.stopPropagation()
  e.preventDefault()

$(document).on 'signed_in', ->
  window.location.reload(true)

$(document).on 'social_error', (e) ->
  if typeof FactlinkApp == 'object'
    FactlinkApp.NotificationCenter.error(e.originalEvent.detail)
  else
    _.defer -> alert(e.originalEvent.detail)
