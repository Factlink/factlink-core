(function(Factlink, $, _, easyXDM) {
  // Initiate the easyXDM object
  Factlink.remote = new easyXDM.Rpc({
    // The URL to load
    remote: window.location.protocol + '//' + FactlinkConfig.api + "/factlink/intermediate",
    // The iFrame where the intermediate should be loaded in
    container: "factlink-modal-frame"
  }, {
    // See modal.js #Factlink.modal
    local: Factlink.modal,
    remote: {
      createEvidence: {},
      createNewEvidence: {},
      createFactlink: {},
      showFactlink: {},
      position: {},
      opinionateFactlink: {}
    }
  });
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);