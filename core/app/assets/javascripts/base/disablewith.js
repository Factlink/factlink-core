(function () {
  $('a[data-disable-with]:not([data-remote])')
    .live('click', setLoadingText);

  function setLoadingText() {
    $(this).html( $(this).attr('data-disable-with') )
      .addClass('disabled');
  }
}());
