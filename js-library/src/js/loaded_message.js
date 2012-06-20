(function(Factlink, $, _, easyXDM, window, undefined) {
  Factlink.loadedMessage = function(fact_id){
    $('#fl').append("<div class='fl-message' style='display:none'> Factlink is loaded</div>");
    $('#fl .fl-message').fadeIn('slow');
    setTimeout(function() {
      $('#fl .fl-message').fadeOut('slow');
    }, 2545);
  };

  $(window).bind('factlink.factsLoaded', function(){
    if (Factlink !== undefined && FactlinkConfig !== undefined && FactlinkConfig.client === 'bookmarklet') {
      Factlink.loadedMessage();
    }
  });

})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
