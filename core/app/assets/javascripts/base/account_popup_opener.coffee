modalIframeTemplate = _.template '''
  <div class="modal-layer" id="modal-layer"><div class="modal-window">
    <iframe class="sign_in_or_up_iframe" src="<%- options.target %>"></iframe>
  </div>
  <div class="modal-layer-close-background"></div></div>
  '''.trim(), null, variable: 'options'

singleton_modal_container = do ->
  el = null
  remove = -> el && el.parentNode && document.body.removeChild(el)
  create = ->
    remove()
    el = document.body.appendChild document.createElement 'div'
  { create: create, remove: remove }

showPopup = (url) ->
  $modalEl = $($.parseHTML(modalIframeTemplate(target:url)))
  $modalEl.find('iframe').on('load', -> $modalEl.fadeIn('fast'))
  $modalEl.appendTo(document.body)
  $modalEl.find('.modal-layer-close-background').on 'click', ->
    $modalEl.fadeOut 'fast', ->
      $modalEl.remove()

$('html').on 'click', '.js-accounts-popup-link', (e) ->
  e.stopPropagation()
  e.preventDefault()
  showPopup($(e.target).attr("href"))

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
