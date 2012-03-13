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
