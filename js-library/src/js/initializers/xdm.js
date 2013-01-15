(function(Factlink, $, _, easyXDM, window, undefined) {
  // Initiate the easyXDM object
  Factlink.remote = new easyXDM.Rpc({
    // The URL to load
    remote: FactlinkConfig.api + "/factlink/intermediate",
    // The iFrame where the intermediate should be loaded in
    container: "factlink-modal-frame"
  }, {
    // See modal.js #Factlink.modal
    local: Factlink.modal,
    remote: {
      showFactlink: {},
      prepareNewFactlink: {},
      position: {}
    }
  });

  $(window).trigger("factlink.loaded");
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
