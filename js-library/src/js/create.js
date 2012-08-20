(function(Factlink, $, _, easyXDM, window, undefined) {

  var popupTimeout;

  function getTextRange() {
    var doc = window.document;
    var d;

    if (doc.getSelection) {
      d = doc.getSelection();
    } else if (doc.selection) {
      d = doc.selection.createRange().text;
    } else {
      d = '';
    }
    return d;
  }

  Factlink.createFactFromSelection = function(opinion, callback, errorCallback){
    var selInfo = Factlink.getSelectionInfo();

    var success = function() {
      Factlink.modal.show.method();
      Factlink.trigger('modalOpened');
    };

    var onCreated = function(data) {
      // var factObjs = Factlink.modal.highlightNewFactlink.method(data.displaystring,
      //                                                           data.id,
      //                                                           data.score_dict_as_percentage);
      // Factlink.trigger('factlinkAdded');
    };

    Factlink.remote.prepareNewFactlink( selInfo.text,
                                    Factlink.siteUrl(),
                                    selInfo.title,
                                    success,
                                    onCreated);
  };

  // We make this a global function so it can be used for direct adding of facts
  // (Right click with chrome-extension)
  Factlink.getSelectionInfo = function() {
    // Get the selection object
    var selection = getTextRange();

    //TODO: Add passage detection here
    return {
      text: selection.toString(),
      passage: "",
      title: window.document.title
    };
  };

  // This method will position a frame at the coordinates, either the left-top or
  // the right-top will be placed at x,y (preferably left-top)
  Factlink.positionFrameToCoord = function($frame, x, y, centered) {

    // First, set `absolute` so width can be determined
    $frame.css({
      position: 'absolute'
    });

    if ($(window).width() < (x + $frame.outerWidth(true) - $(window).scrollLeft())) {
      x -= $frame.outerWidth(true);
    }

    if ($(window).height() < (y + $frame.outerHeight(true) - $(window).scrollTop())) {
      y -= $frame.outerHeight(true);
    }

    // Position the middle of the frame at the mouse pointer\
    // in stead of the top left corner
    if (centered === true) {
      x = x - ($frame.outerWidth(true) / 2);
      y = y - ($frame.outerHeight(true) / 2);
    }

    // Position the frame
    $frame.css({
      top: y + 'px',
      left: x + 'px'
    });
  };


})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);

