popupCenter = (url, width, height, name) ->
  left = (screen.width/2)-(width/2)
  top = (screen.height/2)-(height/2)
  window.open(url, name, "menubar=no,toolbar=no,status=no,width=#{width},height=#{height},toolbar=no,left=#{left},top=#{top}")

$('html').on 'click', ".social-services-buttons a.popup", (e) ->
  element = e.toElement
  popupCenter($(element).attr("href"), $(element).attr("data-width"), $(element).attr("data-height"), "authPopup")
  e.stopPropagation()
  e.preventDefault()

$(document).on 'signed_in', ->
  window.location.reload(true)

$(document).on 'social_error', (e) ->
  if typeof FactlinkApp == 'object'
    FactlinkApp.NotificationCenter.error(e.originalEvent.detail)
  else
    _.defer -> alert(e.originalEvent.detail)
