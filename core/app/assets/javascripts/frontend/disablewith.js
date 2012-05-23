(function () {
  $('a[data-disable-with][data-onloadingtext]')
    .live("ajax:before", setLoadingText);

  $("a[data-disable-with][data-oncompletetext]")
    .live("ajax:complete", setCompletedText);

  $('a[data-disable-with][data-onloadingtext]:not([data-remote])')
    .live('click', setLoadingText);

  function setLoadingText() {
    $(this)
      .text( $(this).attr('data-onloadingtext') )
      .attr('onclick','return false;')
      .addClass('disabled');
  }

  function setCompletedText() {
    $(this).text( $(this).attr('data-oncompletetext') );
  }
}());
