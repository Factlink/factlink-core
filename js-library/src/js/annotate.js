(function(Factlink, $, _, easyXDM, undefined) {
var timeout;
var pageX;
var pageY;

Factlink.startAnnotating = function() {
  console.info( "Factlink:", "startAnnotating" );
  $('body').bind('mouseup.factlink', function(e) {
    window.clearTimeout(timeout);

    if (Factlink.prepare.isVisible()) {
      Factlink.prepare.hide();
      Factlink.prepare.resetFactId();
    }

    // We execute the showing of the prepare menu inside of a setTimeout
    // because of selection change only activating after mouseup event call.
    // Without this hack there are moments when the prepare menu will show
    // without any text being selected
    timeout = setTimeout(function() {
      // Retrieve all needed info of current selection
      var selectionInfo = Factlink.getSelectionInfo();

      pageX = e.pageX;
      pageY = e.pageY;

      // Check if the selected text is long enough to be added
      if ((selectionInfo.text !== undefined && selectionInfo.text.length > 1) &&
          (! $(e.target).is(':input') )){
        Factlink.prepare.show(pageY, pageX);
      }
    }, 200);
  });
};

Factlink.stopAnnotating = function() {
  console.info( "Factlink:", "stopAnnotating" );
  $('body').unbind('mouseup.factlink');
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
