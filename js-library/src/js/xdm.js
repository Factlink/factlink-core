(function( Factlink ) {
// Initiate the easyXDM object
Factlink.remote = new easyXDM.Rpc({
        //@TODO: This ain't being used right now (in Chrome)
		swf: Factlink.conf.api.loc + "/client/easyXDM/src/easyxdm.swf",
		// The URL to load
		remote: Factlink.conf.api.loc + "/factlink/intermediate",
		// The iFrame where the intermediate should be loaded in
		container: "factlink-modal-frame"
	}, {
	    // See modal.js #Factlink.modal
		local: Factlink.modal,
		remote: {
		    prepareNewFactlink: {},
		    showFactlink: {},
		    position: {},
		}
	});
})( window.Factlink );