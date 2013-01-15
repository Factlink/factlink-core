(function(Factlink, $, _, easyXDM, window, undefined) {
Factlink.Facts = [];

Factlink.startHighlighting = function() {
  console.info( "Factlink:", "startHighlighting" );
  fetchFacts()
    .done(function(data) {
      // If there are multiple matches on the page, loop through them all
      for (var i = 0; i < data.length; i++) {
        // Select the ranges (results)
        $.merge( Factlink.Facts,
                 Factlink.selectRanges(
                   Factlink.search(data[i].displaystring),
                   data[i]._id,
                   data[i].score_dict_as_percentage
                 )
                );
      }

      $(window).trigger('factlink.factsLoaded');
    });
};

Factlink.stopHighlighting = function() {
  console.info( "Factlink:", "stopHighlighting" );
  for( var i = 0; i < Factlink.Facts.length; i++ ) {
    Factlink.Facts[i].destroy();
  }

  Factlink.Facts = [];
};

// Function which will collect all the facts for the current page
// and select them.
// Returns deferred object
function fetchFacts() {
  // The URL to the Factlink backend
  var src = FactlinkConfig.api + '/site?url=' + encodeURIComponent(Factlink.siteUrl());

  // We use the jQuery AJAX plugin
  return $.ajax({
    url: src,
    dataType: "jsonp",
    crossDomain: true,
    type: "GET",
    jsonp: "callback"
  });
}

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
