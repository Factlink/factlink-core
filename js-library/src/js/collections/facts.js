(function(Factlink, $, _, easyXDM, undefined) {
    
var FactsList = function() {
  var facts = [];
  
  this.get = function(id) {
    return facts[id];
  };
  
  this.push = function(fact) {
    facts.push( fact );
    
    return facts.length - 1;
  };
};

Factlink.Facts = new FactsList();

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
