(function(Factlink, $, _, easyXDM) {
  var timeout;
  var popupTimeout;
  // Function which will return the Selection object
  //@TODO: Add rangy support for IE
  // Load the needed prepare menu & put it in a container
  var templateUrl, $prepare = $('<div />').attr('id', 'fl-prepare').appendTo("body");

  if (FactlinkConfig.modus === 'addToFact') {
    templateUrl = '//' + FactlinkConfig.api + "/template/addToFact.html";
    loadTemplate(templateUrl);
  } else {
    templateUrl = '//' + FactlinkConfig.api + "/template/create.html";
    loadTemplate(templateUrl);
  }

  function loadTemplate(url) { 
    var template; 
    $.ajax({
      url: url,
      crossDomain: true,
      dataType: "jsonp",
      cache: false,
      jsonp: "callback",
      success: function(data) {
        template = _.template(data);
        
        $prepare.html(template);


        bindPrepareHover($prepare);
        bindPrepareClick($prepare);
        $prepare.bind("factlink:switchLabel", function(e, from, to) { switchLabel(from, to); } );
      }, 
      error: function(data) { 
        console.log(data);
      }
   });
   return template;
  }


  function switchLabel(from, to) { 
    $prepare.find(".fl-label[data-label=" + from +"]").hide(); 
    $prepare.find(".fl-label[data-label=" + to +"]").fadeIn('fast');
  }

  function bindPrepareHover($element) { 
    var balloon = $element.find("#fl-balloon-popup");
    function hoverIn() { 
       balloon.stop().fadeTo('fast', 1).show();
    }
    function hoverOut() {
       balloon.stop().fadeTo('fast', 0, function() {
        $(this).hide(); 
      });
    }
    $element.bind("fl-labels").hover(hoverIn, hoverOut); 
  }


  function bindPrepareClick($element) {
    $element.find('a').bind('mouseup', function(e) {
      e.stopPropagation();
    }).bind('click', function(e) {
      e.preventDefault();

      Factlink.submitSelection(e.currentTarget.id, function(factId) {
        showFactAddedPopup(factId, e.pageX, e.pageY);
      });

      // Hide the fl-prepare context menu
      $element.fadeOut(100);
    });
  }


  function showFactAddedPopup(factId, x, y) {
    // Create `add evidence` popup after succesful addition of the fact.            
    var popup = $('<div/>').addClass('fl-popup').html("Fact added<span class='button' data-factid='" + factId + "' onclick='Factlink.showInfo(el=this, showEvidence=true); $(\"div.fl-popup\").fadeOut(100);' >Add evidence?</span>").appendTo("body");

    // Close the popup when clicked outside the area
    $(document).bind('click', function(e) {
      popup.fadeOut(100);
    });

    // Don't clost the popup when clicked on the popup itself
    popup.bind('click', function(e) {
      e.stopPropagation();
    });

    // Position popup on mouse position
    Factlink.positionFrameToCoord(popup, x, y, true);

    // Start the timout to hide the popup after a while
    $('div.fl-popup').hover(function() {
      // handlerIn
      clearTimeout(popupTimeout);
      // handlerOut
    }, function() {
      startTimer();
    });

    function startTimer() {
      popupTimeout = setTimeout(function(){
        $('div.fl-popup').fadeOut(100);
      }, 3000);
    }

    startTimer();
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

  Factlink.submitSelection = function(opinion, callback) {
    var selInfo = Factlink.getSelectionInfo();
    if (FactlinkConfig.modus === "addToFact") {
      if (Factlink.prepare.factId) {
          Factlink.remote.createEvidence(Factlink.prepare.factId, Factlink.siteUrl(), opinion, selInfo.title);
      } else {
          Factlink.remote.createNewEvidence(selInfo.text, selInfo.passage, Factlink.siteUrl(), opinion, selInfo.title);
      }
    } else {
      Factlink.remote.createFactlink(selInfo.text, selInfo.passage, Factlink.siteUrl(), selInfo.title, opinion,
        function(factId) {
          if ($.isFunction(callback)) {
            callback(factId);
          }
        }
      );      
    }
  };


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
  Factlink.positionFrameToCoord = function($frame, x, y, centered) {

    // First, set `absolute` so width can be determined
    $frame.css({
      position: 'absolute'
    });

    if ($(window).width() < (x + $frame.outerWidth(true) - $(window).scrollLeft())) {
      x -= $frame.outerWidth(true);

      // console.log("outerWIdth: " + $frame.outerWidth(true));
    }

    if ($(window).height() < (y + $frame.outerHeight(true) - $(window).scrollTop())) {
      y -= $frame.outerHeight(true);

      // console.log("outerHEight: " + $frame.outerHeight(true));
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

  Factlink.prepare = {
    factId: null,
    show: function(x, y) {
      if ($prepare.is(':visible')) {
        $prepare.hide();
        Factlink.prepare.resetFactId();
      }

      Factlink.positionFrameToCoord($prepare, x, y);

      $prepare.fadeIn(100);
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
        $prepare.fadeIn(100);
      }
    }, 100);
  });
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);

