Factlink.Prepare = function() {
  var hasFocus = false;
  var el;
  var factId;
  var facts;
  var self = this;
  var pageX;
  var pageY;
  var loadingTimeoutID;
  var loading = false;

  function initialize(tmpl) {
    var createFact = Factlink.createFactFromSelection;

    el = $(tmpl());
    el.appendTo(Factlink.el);
    el.hide();

    el.bind('mouseup', function(e) {
      e.stopPropagation();
    }).bind('click', function(e) {
      e.preventDefault();

      self.startLoading();

      createFact();
    });

    bindAddEvidenceClick();
  }

  function bindAddEvidenceClick() {
    el.delegate(".fl-created","click", function(e) {
      if ( facts.length > 0 ) {
        facts[0].click();
        self.hide(100);
      }
    });
  }

  this.show = function(top, left) {
    pageX = left;
    pageY = top;
    self.resetType();
    Factlink.set_position_of_element(top,left,window,el);
    el.fadeIn('fast');
  };

  this.hide = function(callback) {
    el.fadeOut('fast', function() {
      if (loading) { self.stopLoading(); }

      if ( $.isFunction(callback) ) {
        callback();
      }
    });
  };

  this.startLoading = function() {
    loading = true;
    el.addClass('fl-loading');
  };
  this.stopLoading = function() {
    loading = false;
    this.hide( function() {
      el.removeClass('fl-loading');
    });
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


  var types = ["fl-create","fl-created"];

  this.setType = function(str) {
    el.removeClass(types.join(" ")).addClass(str);
  };

  this.resetType = function() {
    el.removeClass(types.join(" ")).addClass(types[0]);
    el.removeClass("right left");
    facts = [];
    self.resetFactId();
  };


  initialize.apply(this, arguments);
};
