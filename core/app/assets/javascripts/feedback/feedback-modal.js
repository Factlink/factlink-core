(function(){
  var popup = $('#feedback-popup');

  $('.feedback').live('click', function() {
    $('#feedback-footer').removeClass('feedback-footer');

    $("#feedback-form")[0].reset();
    $("#feedback-modal .alert").css("display", "none");

    popup.modal('show');
  });

  var modal = $('#feedback-modal');

  $(".cancel", modal).live("click", function() {
    popup.modal('hide');
  });

  modal.delegate(".alert-success .close", 'click', function(e){
    $(e.target).closest('.alert-success').hide();
  });

  $("#feedback-form").live("ajax:success ajax:error", function(e, data) {
    $("#feedback-form")[0].reset();
    var alertMsg = $(".alert-success", modal);
    alertMsg.show().find('.message').html(data.msg);
    alertMsg.alert();
  });

})();


