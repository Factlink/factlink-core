//= require jquery
//= require twitter/bootstrap

$(function () {
  updateHeight();

  $(window).on('resize', updateHeight);

  $('a.close').on('click', function () {
    // Wait till it's closed, ugly?
    setTimeout(updateHeight, 10);
  });

  $('.cancel').on('click', function () {
    console.info( "TEST" );
  });

  $('.cancel').on('click', window.parent.closeFeedbackFrame);

});

function updateHeight() {
  var $iframe = window.parent.$('#feedback_frame>iframe');

  $iframe.css({
    height: $('body').outerHeight() + "px",
    marginTop: - $('body').outerHeight()/2 + "px"
  });
}

function onCloseFrame() {
  $('.alert').remove();
}
