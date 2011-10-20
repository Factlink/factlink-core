(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Fact = function() {
  var elements;
  var id;
  // This is to scare Mark:
  var timeout;
  var balloon;
  
  initialize.apply(this, arguments);
  
  function initialize (id, elems) {
    elements = elems;
    id = id;
    
    balloon = new Factlink.Balloon(id);
    
    bindHover();
  }
  
  function bindHover () {
    $(elements).bind('mouseenter', function(e) {
      balloon.show();
    }).bind('mouseleave', function(e) {
      balloon.hide();
    });
  }
  
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);