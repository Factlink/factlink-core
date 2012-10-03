//= require jquery
//= require twitter/bootstrap

$(function () {
  updateHeight();

  $(window).on('resize', updateHeight);

  $('a.close').on('click', function () {
    // Wait till it's closed, ugly?
    setTimeout(updateHeight, 10);
  });

  $('.cancel').on('click', window.parent.closeFeedbackFrame);

});

function updateHeight() {
  var $feedback_frame = window.parent.$('#feedback_frame');
  var $iframe = $feedback_frame.find('iframe');

  $iframe.css({
    height: $('body').outerHeight()
  });

  $feedback_frame.css({
    marginTop: - $feedback_frame.outerHeight()/2 + "px"
  });
}

function onCloseFrame() {
  $('.alert').remove();
}
