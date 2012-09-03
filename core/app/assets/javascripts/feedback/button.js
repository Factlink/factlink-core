(function() {
	$('#feedback_button').on('click', openFeedbackFrame);
	$('#feedback_frame>.dimmer').on('click', closeFeedbackFrame);
}());

function closeFeedbackFrame() {
	$('#feedback_frame').fadeOut();
}

function openFeedbackFrame() {
	$('#feedback_frame').fadeIn();
}