showPopup = (url) ->
  width  = 640
  height = 400
  left   = (screen.width/2)-(width/2)
  top    = (screen.height/2)-(height/2)
  popup_window = window.open url, "authPopup",
    "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},left=#{left},top=#{top}"
  popup_window.focus()

$('html').on 'click', '.js-accounts-popup-link', (e) ->
  showPopup($(e.target).attr("href"))
  e.stopPropagation()
  e.preventDefault()

$(document).on 'signed_in', ->
  window.location.reload(true)
  mp_track 'User: Sign in'

$(document).on 'authorized', (e) ->
  provider_name = e.originalEvent.detail
  currentUser?.setServiceConnected provider_name

$(document).on 'account_error', (e) ->
  if typeof FactlinkApp == 'object'
    FactlinkApp.NotificationCenter.error(e.originalEvent.detail)
  else
    _.defer -> alert(e.originalEvent.detail)
