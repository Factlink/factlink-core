var Factlink = window.Factlink = (function() {
// Empty Factlink object
var Factlink = {
    results: []
};

// Function which will collect all the facts for the current page
// and select them.
Factlink.getTheFacts = function() {
    var loc = window.location,
        // The URL to the Factlink backend
        src = Factlink.CONF.API.loc + '/site?url=' + 
              loc.protocol + 
              '//' + 
              loc.hostname + 
              loc.pathname;
    
	//@TODO Fix the Loader
    // Update the loader
    // FL.Loader.updateStatus( "Retrieving the facts from the server" );
    
    // Add the stylesheet
    Factlink.util.addStyleSheet( Factlink.CONF.css );
    
    // We use the jQuery AJAX plugin
    $.ajax({
        url: src,
        dataType: "jsonp",
        crossDomain: true,
        type: "GET",
        jsonp: "callback"
    })
        // Callback which is called when the response is loaded, will contain
        // the JSON data
        .success(function(data){
            // If there are multiple matches on the page, loop through them all
            for ( var i = 0; i < data.length; i++ ) {
                //@TODO Fix the Loader
				// Update the loader
                // FL.Loader.updateStatus( "Finding matches for fact: \"" + data[i].displaystring + "\"" );
                
                // Select the ranges (results)
                Factlink.selectRanges( Factlink.search( data[i].displaystring ), data[i]._id );
            }
            
            //@TODO Fix the Loader
            // Done loading
            // FL.Loader.finish();
        });
};

Factlink.destroy = function() {
    try {
        Factlink.overlay.hide();
        Factlink.iframe.remove();
    } catch (e) {}
    
    // Finally destroy the object
    window.Factlink = null;
};


//                                                                          //
//                                                                          //
//                                  UTILS                                   //
//                                                                          //
//                                                                          //

Factlink.util = {};

// IE anyone?
Factlink.util.hasInnerText = (document.getElementsByTagName("body")[0].innerText !== undefined) ? true : false;

// Util function to load a stylesheet
Factlink.util.addStyleSheet = function(url) {
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

// Function which walks the DOM in HTML source order
// as long as func does not return false
// Inspiration: Douglas Crockford, JavaScript: the good parts
Factlink.util.walkTheDOM = function walk(node, func) {
    if ( func(node) !== false ) {
        node = node.firstChild;
        while (node) {
            if (walk(node, func) !== false) {
                node = node.nextSibling;
            } else {
                return false;
            }
        }
    } else {
        return false;
    }
};

// Factlink debug
Factlink.util.debug = function() {
    if ( window.console && window.console.info ) {
        window.console.info.apply( window.console, arguments );
    }
};

// Dustin Diaz - $script.js
Factlink.util.domReady = function(fn) {
    /in/.test( document['readyState'] ) ? setTimeout( function() { Factlink.util.domReady(fn); }, 50) : fn();
};

// Expose the Factlink object to the global object
return Factlink;
})();