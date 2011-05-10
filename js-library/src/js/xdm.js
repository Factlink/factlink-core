(function( Factlink ) {
Factlink.$frame = $("<div />")
                    .attr({
                        "id": "factlink-modal-frame"
                    })
                    .appendTo('body');

    // Store the remote URL
var REMOTE = "http://localhost:3000";

// Initiate the easyXDM object
Factlink.remote = new easyXDM.Rpc({
		swf: REMOTE + "/client/easyXDM/src/easyxdm.swf",
		remote: REMOTE + "/factlink/intermediate",
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