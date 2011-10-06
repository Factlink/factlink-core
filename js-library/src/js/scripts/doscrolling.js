(function(Factlink, $, _, easyXDM) {
  $(window).bind('factlink:factsLoaded', function(){
    if (Factlink !== undefined && FactlinkConfig !== undefined && FactlinkConfig.scrollto) {
      // Get al the facts on the current page
      Factlink.scrollTo(FactlinkConfig.scrollto);
    }
  });
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);