$("#user_username").focus( function() {
	$("#user_email_wrapper").animate({'height': 48}, 250, function() {
		$("#user_email").fadeIn();
	});
});
