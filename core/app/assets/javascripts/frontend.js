//= require application
//= require twitter/bootstrap
//= require bubble
//= require modal
//= require_tree ./frontend

$(".alert-message").alert();

$('.topbar').dropdown();
$('.bookmarklet').twipsy({placement:"below",offset:5});

$('.take-the-tour').live('click', function() {
  $('#first-tour-modal').remove();

  // Load the tour
  $.ajax({
    url: "/tour",
    dataType: "html",
    success: function(data) {
      $('body').append(data);
      initTourModal();
    }
  });
});

