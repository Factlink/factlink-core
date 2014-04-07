#This patches jquery_ujs, such that it grabs csrf token from localStorage
#instead of from the meta tag.

updateRailsCsrfMetaTags = ->
  if !$('meta[name=csrf-token]').length
    $('<meta name="csrf-token">').appendTo(document.head)
    $('<meta name="csrf-param">').appendTo(document.head)
  $('meta[name=csrf-token]').attr('content', safeLocalStorage.getItem('factlink_csrf_token'))
  $('meta[name=csrf-param]').attr('content', safeLocalStorage.getItem('factlink_csrf_param'))

updateCsrfTagsBeforeExecution = (func) -> ->
  updateRailsCsrfMetaTags()
  func.apply(@, arguments)

['refreshCSRFTokens', 'CSRFProtection', 'handleMethod'].forEach (name) ->
  $.rails[name] = updateCsrfTagsBeforeExecution $.rails[name]

