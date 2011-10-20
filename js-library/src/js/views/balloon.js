(function(Factlink, $, _, easyXDM, undefined) {
    
Factlink.Balloon = function() {
  var id;
  var el;
  
  initialize.apply(this, arguments);
  
  function initialize(factId) {
    id = factId;
    
    el = $();
  }
  
  this.show = function() {
    console.info( "Showing balloon" );
    el.show();
  };
  
  this.hide = function() {
    console.info( "Hiding balloon" );
    el.hide();
  };
  
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);