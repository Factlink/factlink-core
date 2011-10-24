(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Prepare = function() {
  var hasFocus = false;
  var el;
  var factId;
  var createFact;
  var self = this;
  var timeout;
  
  function initialize(tmpl) {
    el = $(tmpl()).appendTo(Factlink.el);
    
    el.hoverIntent({
      over: function(e) {
        el.addClass('add-active');
      },
      out: function(e) {
        el.removeClass('add-active');
      },
      timeout: 500
    });
    
    if (FactlinkConfig.modus === "addToFact") {
      createFact = Factlink.createEvidenceFromSelection;
    } else {
      createFact = Factlink.createFactFromSelection;
    }
    
    el.find('a').bind('mouseup', function(e) {
      e.stopPropagation();
    }).bind('click', function(e) {
      e.preventDefault();
  
      createFact(e.currentTarget.id, function(factId) {
        Factlink.showFactAddedPopup(factId, e.pageX, e.pageY);
      });
  
      // Hide the fl-prepare context menu
      self.hide(100);
    });
    
    bindBodyClick();
  }
  
  function bindBodyClick() {
    // Bind the actual selecting
    $('body').bind('mouseup', function(e) {
      window.clearTimeout(timeout);

      if (self.isVisible()) {
        self.hide();
        self.resetFactId();
      }

      // We execute the showing of the prepare menu inside of a setTimeout
      // because of selection change only activating after mouseup event call.
      // Without this hack there are moments when the prepare menu will show
      // without any text being selected
      timeout = setTimeout(function() {
        // Retrieve all needed info of current selection
        var selectionInfo = Factlink.getSelectionInfo();

        // Check if the selected text is long enough to be added
        if (selectionInfo.text !== undefined && selectionInfo.text.length > 1) {
          self.show(e.pageY, e.pageX);
        }
      }, 100);
    });
  }
  
  function setRight() {
    el.addClass('right');
    el.removeClass('left');
  }
  
  function setLeft() {
    el.addClass('left');
    el.removeClass('right');
  }
  
  this.show = function(top, left) {
    var x = left,y = top;
    
    el.show();
    
    x -= 30;
    if ($(window).width() < (x + el.outerWidth(true) - $(window).scrollLeft())) {
      x = $(window).width() - el.outerWidth(true);
      
      setLeft();
    } else {      
      if ( x < $(window).scrollLeft() ) {
        x = $(window).scrollLeft();
      }
      
      setRight();
    }
    
    y -= 14 + el.outerHeight(true);
    
    if (y < $(window).scrollTop()) {
      y = $(window).scrollTop() + el.outerHeight(true) + 14;
    }
    
    el.css({
      top: y + 'px',
      left: x + 'px'
    });
  };
  
  this.hide = function() {
    el.hide();
  };
  
  this.isVisible = function() {
    return el.is(':visible');
  };
  
  this.setFactId = function(id) {
    factId = id;
  };
  
  this.resetFactId = function() {
    factId = undefined;
  };
  
  this.getFactId = function() {
    return factId;
  };
  
  initialize.apply(this, arguments);
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);