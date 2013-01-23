Factlink.Balloon = function() {
  var id;
  var el;
  var hasFocus = false;
  var factObj;
  var mouseOutTimeoutID;
  var loadingTimeoutID;
  var loading = false;

  function initialize(factId, fact) {
    id = factId;
    factObj = fact;

    Factlink.templates.getTemplate("indicator", function(tmpl) {
      initializeTemplate(tmpl);
    });
  }

  this.show = function(top, left, fast) {
    window.clearTimeout(mouseOutTimeoutID);
    if (fast === true) {
      hideAll();
      el.show();
    } else {
      mouseOutTimeoutID = window.setTimeout(function() {
        hideAll();
        el.fadeIn('fast');
      }, 200);
    }

    Factlink.set_position_of_element(top,left,window,el);
  };

  this.hide = function(callback) {
    window.clearTimeout(mouseOutTimeoutID);
    el.fadeOut('fast', function() {

      if ( $.isFunction(callback) ) {
          callback();
        }
     });

    if (factObj !== undefined) {
      factObj.stopHighlighting();
    }
  };

  this.isVisible = function() {
    return el.is(':visible');
  };

  this.destroy = function() {
    el.remove();
  };

  this.startLoading = function() {
    loading = true;

    var self = this;

    loadingTimeoutID = setTimeout(function() {
      self.stopLoading();
    }, 17000);

    el.addClass('fl-loading');
  };

  this.stopLoading = function() {
    window.clearTimeout(loadingTimeoutID);
    loading = false;

    this.hide( function() {
      el.removeClass('fl-loading');
    });
  };

  this.loading = function() {
    return loading;
  };

  function initializeTemplate(tmpl) {
    el = $(tmpl(factObj.getObject())).appendTo(Factlink.el);

    el.bind('mouseenter', function() {
      factObj.focus();
    }).bind('mouseleave', function() {
      factObj.blur();
    });

    el.bind('click', function() {
      factObj.click();
    });
  }

  function hideAll() {
    el.closest('#fl').find('.fl-popup').hide();
  }

  initialize.apply(this, arguments);
};
