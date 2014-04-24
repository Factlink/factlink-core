showPopup = (url) ->
  width  = 640
  height = 480
  left   = (screen.width/2)-(width/2)
  top    = (screen.height/2)-(height/2)
  popup_window = window.open url, "authPopup",
    "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},left=#{left},top=#{top}"
  popup_window.focus()

$('html').on 'click', '.js-accounts-popup-link', (e) ->
  showPopup($(e.target).closest('.js-accounts-popup-link').attr("href"))
  e.stopPropagation()
  e.preventDefault()

$(document).on 'account_success', (e) ->
  currentSession.refreshCurrentUser JSON.parse(e.originalEvent.detail)
  # detail is sent across not as object but as JSON, because it is a
  # potentially cross-window object, and IE imposes complex security
  # restrictions on those (e.g. http://forum.jquery.com/topic/obscure-ie-bug-in-jquery-1-4)

$(document).on 'account_error', (e) ->
  Factlink.notificationCenter.error(e.originalEvent.detail)
