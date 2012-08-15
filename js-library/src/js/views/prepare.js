(function(Factlink, $, _, easyXDM, window, undefined) {

Factlink.Prepare = function() {
  var hasFocus = false;
  var el;
  var factId;
  var facts;
  var self = this;
  var timeout;
  var pageX;
  var pageY;

  function initialize(tmpl) {
    var createFact = Factlink.createFactFromSelection;

    el = $(tmpl());
    el.appendTo(Factlink.el);
    el.hide();

    el.bind('mouseup', function(e) {
      e.stopPropagation();
    }).bind('click', function(e) {
      e.preventDefault();

      createFact(e.currentTarget.id, function(factId, factObjs) {
        self.setFactId(factId);
        facts = factObjs;
        self.setType("fl-created");
        setTimeout(function() {
          el.hide();
          //fake mouseover over the first fact
          //TODO: actually do this on the selected fact
          factObjs[0].focus({target: factObjs[0].getElements()[0], pageX: pageX, pageY: pageY,show_fast: true});
        }, 1500);
      });
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

  this.hide = function() {
    el.fadeOut('fast');
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

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
