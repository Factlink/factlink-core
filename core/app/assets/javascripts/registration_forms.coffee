setErrorsOnFields = (formId, fieldErrors) ->
  _.forEach fieldErrors, (errorMessage, field) ->
    el = $("#" + formId + "_user_" + field)

    # el.css border: "1px solid rgb(206, 0, 0)"
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
    popover.css(
      'top':0 + position.top - 5,
      'left':element.width() + position.left + 10,
      )
  else if placement == 'top'
    popover.css(
      'top': position.top-popover.height()-12,
      'left': position.left,
    )
  else
    console.error 'placement not supported'
  element.after(popover)

window.bindForm = (formId) ->
  form = $('#' + formId)

  form.on("ajax:success", (event, data, status, response) ->

    forms = $('.sign_up_form > form')
    _.each forms, (el) ->
      $(el).toggleClass 'success'
      clearPreviousErrorsForForm($(el))
  ).on "ajax:error", (event, response, error) ->
    clearPreviousErrorsForForm(form)

    fieldErrors = JSON.parse(response.responseText)
    setErrorsOnFields formId, fieldErrors

  clearPreviousErrorsForForm = (form) ->
    _.each (form.find "input"), (el) ->
      # $(el).removeClass "error"
      $(el).css border: "1px solid #ccc"
      $(el).popover "destroy"

bindForm "top_registration_form"
bindForm "bottom_registration_form"
