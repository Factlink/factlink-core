Factlink.triggerClick = function () {
  var top = (window.innerHeight/2)-12 + window.pageYOffset,
      left = (window.innerWidth/2)-39.5 + window.pageXOffset;

  if ( Factlink.textSelected() ) {
    Factlink.prepare.show(top, left);
    Factlink.prepare.startLoading();

    Factlink.createFactFromSelection();
  } else {
    $('#fl').append("<div class='fl-message' style='display:none'>Please select text to create a Factlink</div>");

    $('#fl .fl-message').fadeIn('slow');

    setTimeout(function() {
      $('#fl .fl-message').fadeOut('slow');
    }, 2545);
  }
};
