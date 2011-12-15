(function(Factlink, $, _, easyXDM, undefined) {
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
      createEvidence: {},
      createNewEvidence: {},
      showFactlink: {},
      position: {},
      opinionateFactlink: {},
      ajax: {}
    }
  });
  
  Factlink.post = function(path, options) {
    Factlink.ajax(path, $.extend({
      type: "POST"
    }, options));
  };
  
  Factlink.get = function(path, options) {
    Factlink.ajax(path, $.extend({
      type: "GET"
    }, options));
  };
  
  Factlink.ajax = function(path, options) {
    function globalErrorFunction(xhr, status, err) {
      console.info('ERROR : ' + path );
      if (xhr.message.status === 401) {
        alert("Please login to Factlink.");
      }
    }

    function globalSuccessFunction(data) {
      console.info('SUCCESS : ' + path );
    }

    var success = ( $.isFunction(options.success) ? options.success : globalSuccessFunction );
    var error = ( $.isFunction(options.error) ? options.error : globalErrorFunction );
    delete options.success;
    delete options.error;
    
    Factlink.remote.ajax(path, options, success, error);
  };
  
  $(window).trigger("factlink.loaded");
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM);
