(function(Factlink, $, _, easyXDM, undefined) {

Factlink.highlight = function(start) {
  if ( start ) {
    Factlink.startHighlighting();
  } else {
    Factlink.stopHighlighting();
  }
};

Factlink.startHighlighting = function() {
  Factlink.getTheFacts();
};

Factlink.stopHighlighting = function() {
  for( var i = 0; i < Factlink.Facts.length; i++ ) {
    Factlink.Facts[i].destroy();
  }

  Factlink.Facts = [];
};

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
