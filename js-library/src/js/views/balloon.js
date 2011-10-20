(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Balloon = function() {
  var id;
  var el;
  var hasFocus = false;
  var factObj;
  
  initialize.apply(this, arguments);
  
  function initialize(factId, factObj) {
    id = factId;
    factObj = factObj;
    
    Factlink.getTemplate("indicator", function(tmpl) {
      el = $(tmpl()).appendTo(Factlink.el);
      
      el.bind('mouseenter', function() {
        factObj.focus();
      }).bind('mouseleave', function() {
        factObj.blur();
      });
    });
  }
  
  this.show = function(top, left) {
    el.css({
      top: top - el.outerHeight() - 6 + 'px',
      left: left - 30 + 'px'
    }).show();
  };
  
  this.hide = function() {
    el.hide();
  };
  
  this.isVisible = function() {
    return el.is(':visible');
  };
  
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);