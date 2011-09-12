(function(Factlink) {
  var timeout;
  // Function which will return the Selection object
  //@TODO: Add rangy support for IE
  // Load the needed prepare menu & put it in a container
  var urlToLoad, 
      $prepare = $('<div />').attr('id', 'fl-prepare').appendTo("body");

  if (FactlinkConfig.modus === "default") {
    urlToLoad = '//' + FactlinkConfig.api + 'factlink/prepare/new';
  } else if (FactlinkConfig.modus === "addToFact") {
    urlToLoad = '//' + FactlinkConfig.api + 'factlink/prepare/evidence';
  }

  $.ajax({
    url: urlToLoad,
    dataType: "jsonp",
    crossDomain: true,
    cache: false,
    success: function(data) {
      $prepare.html(data);

      bindPrepareClick($prepare);
    }
  });

  Factlink.submitSelection = function(e, callback) {
    var selInfo = Factlink.getSelectionInfo();

    if (FactlinkConfig.modus === "default") {
      Factlink.remote.createFactlink(selInfo.text, selInfo.passage, location.href, selInfo.title, e.currentTarget.id, function(factId) {
        if ($.isFunction(callback)) {
          callback(factId);
        }
      });
    } else {
      if (Factlink.prepare.factId) {
        Factlink.remote.createEvidence(Factlink.prepare.factId, FactlinkConfig.url, e.currentTarget.id, selInfo.title);
      } else {
        Factlink.remote.createNewEvidence(selInfo.text, selInfo.passage, FactlinkConfig.url, e.currentTarget.id, selInfo.title);
      }
    }
  };

  function bindPrepareClick($element) {
    $element.find('a').bind('mouseup', function(e) {
      e.stopPropagation();
    }).bind('click', function(e) {
      e.preventDefault();

      Factlink.submitSelection(e);

      $element.hide();
    });
  }

  function getTextRange() {
    var d;
    
    if (window.getSelection) {
      d = window.getSelection();
    } else if (document.getSelection) {
      d = document.getSelection();
    } else if (document.selection) {
      d = document.selection.createRange().text;
    } else {
      d = '';
    }
    return d;
  }

  function getTitle() {
    return document.title;
  }

  // We make this a global function so it can be used for direct adding of facts
  // (Right click with chrome-extension)
  Factlink.getSelectionInfo = function() {
    // Get the selection object
    var selection = getTextRange();

    var title = getTitle();
    //TODO: Add passage detection here
    return {
      text: selection.toString(),
      passage: "",
      title: title
    };
  };

  // This method will position a frame at the coordinates, either the left-top or 
  // the right-top will be placed at x,y (preferably left-top)
  Factlink.positionFrameToCoord = function($frame, x, y) {
    if ($(window).width() < (x + $frame.outerWidth(true) - $(window).scrollLeft())) {
      x -= $frame.outerWidth(true);
    }

    if ($(window).height() < (y + $frame.outerHeight(true) - $(window).scrollTop())) {
      y -= $frame.outerHeight(true);
    }

    $frame.css({
      position: 'absolute',
      top: y + 'px',
      left: x + 'px'
    });
  };

  Factlink.prepare = {
    factId: null,
    show: function(x, y) {
      if ($prepare.is(':visible')) {
        $prepare.hide();
        Factlink.prepare.resetFactId();
      }

      Factlink.positionFrameToCoord($prepare, x, y);

      $prepare.show();
    },
    setFactId: function(factId) {
      this.factId = factId;
    },
    resetFactId: function() {
      delete this.factId;
    }
  };

  // Bind the actual selecting
  $('body').bind('mouseup', function(e) {
    window.clearTimeout(timeout);

    if ($prepare.is(':visible')) {
      $prepare.hide();
      Factlink.prepare.resetFactId();
    }

    Factlink.positionFrameToCoord($prepare, e.pageX, e.pageY);

    // We execute the showing of the prepare menu inside of a setTimeout 
    // because of selection change only activating after mouseup event call.
    // Without this hack there are moments when the prepare menu will show 
    // without any text being selected
    timeout = setTimeout(function() {
      // Retrieve all needed info of current selection
      var selectionInfo = Factlink.getSelectionInfo();

      // Check if the selected text is long enough to be added
      if (selectionInfo.text !== undefined && selectionInfo.text.length > 1) {
        $prepare.show();
      }
    }, 100);
  });
})(window.Factlink);
