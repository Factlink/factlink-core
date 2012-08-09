(function () {
  $('a[data-disable-with]:not([data-remote])')
    .live('click', setLoadingText);

  function setLoadingText() {
    $(this).text( $(this).attr('data-disable-with') )
      .addClass('disabled');
  }
}());
