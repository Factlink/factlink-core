Factlink.Fact = function() {
  var elements;
  // This is to scare Mark:
  var timeout;
  var highlight_timeout;

  // The balloon which corresponds to this Fact
  var balloon;

  var _obj;
  // For use inside other function scopes
  var self = this;
  // Internal object which will hold all bound event handlers
  var _bound_events = {};
  // If you want to support more events add them to this variable:
  var _events = ["focus", "blur", "click", "update"];

  function initialize(id, elems, opinions) {
    elements = elems;

    _obj = {
      "id": id,
      "opinions": opinions
    };

    createEventHandlers(_events);

    highlight();

    balloon = new Factlink.Balloon(id, self);

    // Bind the own events
    $(elements)
      .bind('mouseenter', self.focus)
      .bind('mouseleave', self.blur)
      .bind('click', self.click);

    bindFocus();

    bindClick(id);

    this.stopHighlighting(1500);
  }

  // This may look like some magic, but here we expose the Fact.blur/focus/click
  // methods
  function createEventHandlers(events) {
    for ( var i = 0; i < events.length; i++ ) {
      _bound_events[events[i]] = [];

      self[events[i]] = (function(i) {
        var e = events[i];

        return function() {
          var args = [e].concat(Array.prototype.slice.call(arguments));

          if ( $.isFunction( args[1] ) ) {
            bind.apply(this, args);
          } else {
            trigger.apply(this, args);
          }
        };
      })(i);
    }
  }

  function bind(type, fn) {
    _bound_events[type].push(fn);
  }

  function trigger(type) {
    var args = Array.prototype.slice.call(arguments);

    args.shift();

    for (var i = 0; i < _bound_events[type].length; i++) {
      _bound_events[type][i].apply(this, args);
    }
  }

  function highlight() {
    clearTimeout(highlight_timeout);

    $( elements ).addClass('fl-active');
  }

  this.stopHighlighting = function(timer) {
    clearTimeout(highlight_timeout);

    if ( timer ) {
      highlight_timeout = setTimeout(function() {
        $( elements ).removeClass('fl-active');
      }, timer);
    } else {
      $( elements ).removeClass('fl-active');
    }
  };

  function bindFocus() {
    self.focus(function(e) {
      clearTimeout(timeout);

      highlight();

      if ( ! balloon.isVisible() ) {
        // Need to call a direct .hide() here to make sure not two popups are
        // open at a time
        Factlink.el.find('div.fl-popup').hide();

        balloon.show($(e.target).offset().top, e.pageX, e.show_fast);
      }
    });

    self.blur(function(e) {
      clearTimeout(timeout);

      if ( ! balloon.loading() ) {
        self.stopHighlighting();

        timeout = setTimeout(function(){
          balloon.hide();
        }, 300);
      }
    });
  }

  function bindClick(id) {
    self.click(function(e) {
      var self = this;

      balloon.startLoading();

      Factlink.showInfo(id, function successFn() {
        balloon.stopLoading();
      });
    });
  }

  this.getObject = function() {
    return _obj;
  };

  this.getElements = function() {
    return elements;
  };

  this.destroy = function() {
    for ( var i = 0; i < elements.length; i++ ) {
      var $el = $(elements[i]);

      var html = $el.html();

      if ( ! $el.is('.fl-first') ) {
        $el.before(html);
      }

      $el.remove();
    }

    balloon.destroy();
  };

  initialize.apply(this, arguments);
};