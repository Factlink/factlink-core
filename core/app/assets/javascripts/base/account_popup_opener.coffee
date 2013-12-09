modalIframeTemplate = _.template '''
  <div class="modal-layer"><div class="modal-layer-inner">
    <iframe class="sign_in_or_up_iframe" src="<%- options.target %>"></iframe>
  </div></div>
  ''', null, variable: 'options'

singleton_modal_container = do ->
  el = null
  remove = -> el && el.parentNode && document.body.removeChild(el)
  create = ->
    remove()
    el = document.body.appendChild document.createElement 'div'
  { create: create, remove: remove }


showPopup = (url) ->
  containerEl = singleton_modal_container.create()
  containerEl.innerHTML = modalIframeTemplate target:url

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
