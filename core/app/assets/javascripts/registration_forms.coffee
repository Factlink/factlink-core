setErrorsOnFields = (formId, fieldErrors) ->
  _.forEach fieldErrors, (errorMessage, field) ->
    el = $("#" + formId + "_user_" + field)

    # el.css border: "1px solid rgb(206, 0, 0)"
    el.addClass "error"
    showErrorPopover el, "#{field} #{errorMessage}", formId

showErrorPopover = (element, errorMessage, formId) ->
  placementForForm = (formId) ->
    if formId == "bottom_registration_form"
      placement = "top"
    else
      placement = "right"

  options =
    title: ""
    content: errorMessage
    trigger: "manual"
    placement: placementForForm(formId)

  element.popover options
  element.popover "show"

window.bindForm = (formId) ->
  form = $('#' + formId)

  form.on("ajax:success", (event, data, status, response) ->
    clearPreviousErrorsForForm( $('form') )


    console.info data
  ).on "ajax:error", (event, response, error) ->
    clearPreviousErrorsForForm(form)

    fieldErrors = JSON.parse(response.responseText)
    setErrorsOnFields formId, fieldErrors

  clearPreviousErrorsForForm = (form) ->
    _.each (form.find "input"), (el) ->
      # $(el).removeClass "error"
      $(el).css border: "1px solid #ccc"
      $(el).popover "destroy"


