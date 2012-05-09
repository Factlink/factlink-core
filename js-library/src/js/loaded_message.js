(function(Factlink, $, _, easyXDM, undefined) {
  Factlink.loadedMessage = function(fact_id){
    console.info('Factlink is fully loaded; this message will appear on screen some day soon.');
  };

  $(window).bind('factlink.factsLoaded', function(){
    if (Factlink !== undefined && FactlinkConfig !== undefined && FactlinkConfig.client === 'bookmarklet') {
      Factlink.loadedMessage();
    }
  });
  
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
