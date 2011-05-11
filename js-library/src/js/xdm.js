(function( Factlink ) {
Factlink.$frame = $("<div />")
                    .attr({
                        "id": "factlink-modal-frame"
                    })
                    .appendTo('body');

// Initiate the easyXDM object
Factlink.remote = new easyXDM.Rpc({
		swf: Factlink.conf.api.loc + "/client/easyXDM/src/easyxdm.swf",
		remote: Factlink.conf.api.loc + "/factlink/intermediate",
		container: "factlink-modal-frame"
	}, {
	    // See modal.js #Factlink.modal
		local: Factlink.modal,
		remote: {
		    prepareNewFactlink: {},
		    showFactlink: {}
		}
	});
})( window.Factlink );