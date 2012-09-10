(function() {
  $('#feedback_button').on('click', openFeedbackFrame);
  $('#feedback_frame>.dimmer').on('click', closeFeedbackFrame);
}());

function closeFeedbackFrame() {
  $('#feedback_frame').fadeOut();
  $('#feedback_frame iframe')[0].contentWindow.onCloseFrame();
}

function openFeedbackFrame() {
  $('#feedback_frame').fadeIn();
}
