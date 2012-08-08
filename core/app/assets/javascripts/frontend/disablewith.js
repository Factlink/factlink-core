(function () {
  $('a[data-disable-with][data-onloadingtext]')
    .live("ajax:before", setLoadingText);

  $("a[data-disable-with][data-oncompletetext]")
    .live("ajax:complete", setCompletedText);

  $('a[data-disable-with][data-onloadingtext]:not([data-remote])')
    .live('click', setLoadingText);

  function setLoadingText() {
    var el = $(this);
    var isDataRemote = el.data('remote');

    el.text( $(this).attr('data-onloadingtext') )
      .addClass('disabled');

    if (isDataRemote) {
      el.attr('onclick','return false;');
    }
  }

  function setCompletedText() {
    $(this).text( $(this).attr('data-oncompletetext') );
  }
}());
