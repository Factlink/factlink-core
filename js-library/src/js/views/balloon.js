(function(Factlink, $, _, easyXDM, window, undefined) {

Factlink.Balloon = function() {
  var id;
  var el;
  var hasFocus = false;
  var factObj;
  var timeout;

  function initialize(factId, fact) {
    id = factId;
    factObj = fact;

    Factlink.getTemplate("indicator", function(tmpl) {
      initializeTemplate(tmpl);
    });
  }

  this.show = function(top, left, fast) {
    window.clearTimeout(timeout);
    if (fast === true) {
      hideAll();
      el.show();
    } else {
      timeout = window.setTimeout(function() {
        hideAll();
        el.fadeIn('fast');
      }, 200);
    }

    Factlink.set_position_of_element(top,left,window,el);
  };

  this.hide = function() {
    window.clearTimeout(timeout);
    el.fadeOut('fast');
  };

  this.isVisible = function() {
    return el.is(':visible');
  };

  this.destroy = function() {
    el.remove();
  };

  function initializeTemplate(tmpl) {
    el = $(tmpl(factObj.getObject())).appendTo(Factlink.el);

    el.bind('mouseenter', function() {
      factObj.focus();
    }).bind('mouseleave', function() {
      factObj.blur();
    });

    el.find('div.fl-label').bind('click', function() {
      factObj.click();
    });
  }

  function hideAll() {
    el.closest('#fl').find('.fl-popup').hide();
  }

  initialize.apply(this, arguments);
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
