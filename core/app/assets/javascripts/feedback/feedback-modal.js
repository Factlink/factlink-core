(function(){
  var modal = $('#feedback-modal');

  $('.feedback').live('click', function() {
    modal.modal('show');

    $.ajax({
      url: "/feedback/new",
      dataType: "html",
      success: function(data) {
        modal.html(data);
      }
    });
  });

  $(".cancel", modal).live("click", function() {
    modal.modal('hide');
  })


  $("#feedback-form").live("ajax:success ajax:error", function(e, data) {
    $("#feedback-form")[0].reset();
    var alertMsg = $(".alert-message", modal);
    alertMsg.html(data.msg).show();
    alertMsg.alert();
  });

})();
