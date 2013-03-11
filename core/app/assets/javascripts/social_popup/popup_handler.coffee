if window.opener
  evt = document.createEvent('CustomEvent')
  evt.initCustomEvent('<%= @event %>', true, true, '<%= event_details %>')

  window.opener.document.dispatchEvent(evt)
  window.close()
else
  origin = '<%= request.env['omniauth.origin'] %>'

  if origin != ''
    window.location = origin

