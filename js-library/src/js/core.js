var Factlink = window.Factlink = (function() {

    // Empty Factlink object
var Factlink = {},
    // Util function to load a stylesheet
    addStyleSheet = function(url) {
        if ( typeof this.added_stylesheets !== "object" ) {
            this.added_stylesheets = [];
        }

        if ( this.added_stylesheets.indexOf(url) === -1 ) {
            this.added_stylesheets[url] = 1;

            var style = document.createElement("link");
            style.type = "text/css";
            style.rel = "stylesheet";
            style.href = url;
            document.getElementsByTagName("head")[0].appendChild(style);
        }
    };

// Function which will collect all the facts for the current page
// and select them.
Factlink.getTheFacts = function() {
    var loc = window.location,
        // The URL to the Factlink backend
        src = Factlink.conf.api.loc + '/site?url=' + 
              loc.protocol + 
              '//' + 
              loc.hostname + 
              loc.pathname;
    
	//@TODO Fix the Loader
    // Update the loader
    // FL.Loader.updateStatus( "Retrieving the facts from the server" );
    
    // Add the stylesheet
    addStyleSheet( Factlink.conf.css.loc );
    
    // We use the jQuery AJAX plugin
    $.ajax({
        url: src,
        dataType: "jsonp",
        crossDomain: true,
        type: "GET",
        jsonp: "callback",
        // Callback which is called when the response is loaded, will contain
        // the JSON data
        success: function(data){
            // If there are multiple matches on the page, loop through them all
            for ( var i = 0; i < data.length; i++ ) {
                //@TODO Fix the Loader
				// Update the loader
                // FL.Loader.updateStatus( "Finding matches for fact: \"" + data[i].displaystring + "\"" );
                
                // Select the ranges (results)
                Factlink.selectRanges( Factlink.search( data[i].displaystring ), data[i]._id );
            }

            var $fls = $( 'span.factlink' ).css('backgroundColor', '#B4D5FE');
            
            setTimeout(function(){
                $fls.css('backgroundColor','transparent');
            }, 800);
            
            //@TODO Fix the Loader
            // Done loading
            // FL.Loader.finish();
        }
    });
};

// Expose the Factlink object to the global object
return Factlink;
})();