(function () {
  $('a[data-disable-with]:not([data-remote])')
    .live('click', setLoadingText);

  function setLoadingText() {
    $(this).html( $(this).attr('data-disable-with') )
      .addClass('disabled');
  }
}());

function activateDisableWith($el) {
  function setLoadingText() {
    var $el = $(this);
    if ($el.is("input")) {
      $(this).val( $(this).attr('data-disable-with') )
             .addClass('disabled')
             .prop('disabled', true);
    } else {
      $(this).html( $(this).attr('data-disable-with') )
             .addClass('disabled')
             .prop('disabled', true);
    }
  }

  $el.find('[data-disable-with]:not([data-remote])')
    .on('click', setLoadingText);

}
