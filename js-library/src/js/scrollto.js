(function(Factlink, $, _, easyXDM, undefined) {
  Factlink.scrollTo = function(fact_id){
    $('body')._scrollable().scrollTo("span[data-factid="+fact_id+"]", 800);
  };

  $(window).bind('factlink.factsLoaded', function(){
    if (Factlink !== undefined && FactlinkConfig !== undefined && FactlinkConfig.scrollto) {
      // Get al the facts on the current page
      Factlink.scrollTo(FactlinkConfig.scrollto);
    }
  });
  
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
