(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Fact = function() {
  var elements;
  var id;
  // This is to scare Mark:
  var timeout;
  var highlight_timeout;
  var balloon;
  var eventObj = {'blur': [], 'focus': [], 'click': []};
  var self = this;
    
  function initialize (id, elems) {
    elements = elems;
    id = id;
    
    highlight();
    
    balloon = new Factlink.Balloon(id, self);
    
    // Bind the own events
    $(elements)
      .bind('mouseenter', self.focus)
      .bind('mouseleave', self.blur)
      .bind('click', self.click);
    
    bindHover();
    
    bindClick(id);
    
    stopHighlighting(1500);
  }
    
  this.blur = function() {
    var args = ["blur"].concat(Array.prototype.slice.call(arguments));
    
    if ( $.isFunction( args[1] ) ) {
      bind.apply(this, args);
    } else {
      trigger.apply(this, args);
    }
  };
  
  this.focus = function() {
    var args = ["focus"].concat(Array.prototype.slice.call(arguments));
    
    if ( $.isFunction( args[1] ) ) {
      bind.apply(this, args);
    } else {
      trigger.apply(this, args);
    }
  };
  
  this.click = function() {
    var args = ["click"].concat(Array.prototype.slice.call(arguments));
    
    if ( $.isFunction( args[1] ) ) {
      bind.apply(this, args);
    } else {
      trigger.apply(this, args);
    }
  };
  
  function bind(type, fn) {
    eventObj[type].push(fn);
  }
  
  function trigger(type, fn) {
    var args = Array.prototype.slice.call(arguments);
    
    args.shift();
    
    for (var i = 0; i < eventObj[type].length; i++) {
      eventObj[type][i].apply(this, args);
    }
  }
  
  function highlight() {
    clearTimeout(highlight_timeout);
    
    $( elements ).addClass('fl-active');
  }
  
  function stopHighlighting(timer) {
    clearTimeout(highlight_timeout);

    if ( timer ) {
      highlight_timeout = setTimeout(function() {
        $( elements ).removeClass('fl-active');
      }, timer);
    } else {
      $( elements ).removeClass('fl-active');
    }
  }
  
  function bindHover() {
    self.focus(function(e) {
      clearTimeout(timeout);
      
      highlight();
      
      if ( ! balloon.isVisible() ) {
        // Need to call a direct .hide() here to make sure not two popups are 
        // open at a time
        Factlink.el.find('div.fl-popup').hide();
        
        balloon.show($(e.target).offset().top, e.pageX);
      }
    });
    
    self.blur(function(e) {
      clearTimeout(timeout);
      
      stopHighlighting();
      
      timeout = setTimeout(function(){
        balloon.hide();
      }, 300);
    });
  }
  
  function bindClick(id) {
    self.click(function(e) {
      var self = this;
      // A custom switch-like module
      var modusHandler = (function() {
        return {
          "default": function() {
            Factlink.showInfo(id, false);
          }, 
          addToFact: function() {
            Factlink.prepare.show(e.pageX, e.pageY);
            Factlink.prepare.setFactId(id);
          }
        };
      })();
      modusHandler[FactlinkConfig.modus]();
    });
  }
  
  initialize.apply(this, arguments);
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);