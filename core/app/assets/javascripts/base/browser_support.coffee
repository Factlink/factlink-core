if not $('#ieWarningModal').length
  return

$('#ieWarningModal').modal
  keyboard: false,
  backdrop: "static"

$('#ieWarningModal').on 'hide', ->
  $.ajax
    type: 'PUT',
    url: '/u/seen_messages',
    data:
      message: "unsupported_browser_warning"
