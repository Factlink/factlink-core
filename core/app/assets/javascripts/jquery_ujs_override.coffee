#This patches jquery_ujs, such that it grabs csrf token from localStorage
#instead of from the meta tag.

# Make sure that every Ajax request sends the CSRF token
$.rails.CSRFProtection = (xhr) ->
  token = safeLocalStorage.factlink_csrf_token
  if token
    xhr.setRequestHeader('X-CSRF-Token', token)

# making sure that all forms have actual up-to-date token(cached forms contain old one)
$.rails.refreshCSRFTokens = ->
  csrfToken = safeLocalStorage.factlink_csrf_token
  csrfParam = safeLocalStorage.factlink_csrf_param
  $('form input[name="' + csrfParam + '"]').val(csrfToken);
