# WARNING: This code is only used for the registration forms
#
# Though it was originally generic, it isn't anymore. It should be phased out
# along with Bootstrap

setErrorsOnFields = (formId, fieldErrors) ->
  _.forEach fieldErrors, (errorMessage, field) ->
    el = $("#" + formId + "_user_" + field)

    el.addClass "error"
    showErrorPopover el, "#{field} #{errorMessage}", formId

showErrorPopover = (element, errorMessage, formId) ->
  if formId == "bottom_registration_form"
    placement = "top"
  else
    placement = "right"

  options =
    title: ""
    content: errorMessage
    trigger: "manual"
    placement: placement

  element.popover options
  element.popover "show"

  reposition_elements_popover(element, placement)

reposition_elements_popover = (element, placement)->
  position = element.position()
  popover = element.data('popover').$tip
  popover.css(color: 'black')
  if placement == 'right'
    popover.css
      top: 0 + position.top - 5
      left: element.width() + position.left + 10
  else if placement == 'top'
    if element.selector == "#bottom_registration_form_user_username"
      popover.css
        top: position.top-popover.height() + 4
        left: position.left - 30
    else
      popover.css
        top: position.top-popover.height() + 4
        left: position.left + 0
  else
    console.error 'placement not supported'
  element.after(popover)

bindRegistrationForm = (formId) ->
  form = $('#' + formId)

  form.on "ajax:success", (event, data, status, response) ->
    forms = $('.sign_up_form > form')
    _.each forms, (el) ->
      $(el).toggleClass 'success'
      clearPreviousErrorsForForm($(el))

    registration_code = $("#" + formId + "_user_registration_code").val()
    mp_track 'User: Reserved username', code: registration_code

  form.on "ajax:error", (event, response, error) ->
    clearPreviousErrorsForForm(form)

    fieldErrors = JSON.parse(response.responseText)
    setErrorsOnFields formId, fieldErrors

  clearPreviousErrorsForForm = (form) ->
    _.each (form.find "input.text"), (el) ->
      $(el).removeClass 'error'
      $(el).popover "destroy"

bindRegistrationForm "top_registration_form"
bindRegistrationForm "bottom_registration_form"
