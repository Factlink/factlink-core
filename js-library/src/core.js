var Factlink = (function() {
// Empty Factlink object
var Factlink = function(){
    this.results = [];
    
    // Add the stylesheet to the DOM
    Factlink.util.addStyleSheet("http://factlink:8000/src/styles/factlink.css?" + (new Date()).getTime() );
};

// Function which will collect all the facts for the current page
// and select them.
Factlink.prototype.getTheFacts = function(){
    var loc = window.location,
        // The URL to the Factlink backend
        src = 'http://tom:1337/factlinks_for_url.json?url=' + 
              loc.protocol + 
              '//' + 
              loc.hostname + 
              loc.pathname,
        that = this;
    
    // Update the loader
    FL.Loader.updateStatus( "Retrieving the facts from the server" );
    
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
                // Update the loader
                FL.Loader.updateStatus( "Finding matches for fact: \"" + data[i].displaystring + "\"" );
                
                // Select the ranges (results)
                that.selectRanges( that.search( data[i].displaystring ) );
            }
            
            // Done loading
            FL.Loader.finish();
        });
};


//                                                                          //
//                                                                          //
//                                  UTILS                                   //
//                                                                          //
//                                                                          //

Factlink.util = {};

// IE anyone?
Factlink.util.hasInnerText = (document.getElementsByTagName("body")[0].innerText
     != undefined) ? true : false;

// Util function to load a stylesheet
Factlink.util.addStyleSheet = function(url) {
    var style = document.createElement("link");
    style.type = "text/css";
    style.rel = "stylesheet";
    style.href = url;
    document.getElementsByTagName("head")[0].appendChild(style);
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
        window.console.info.apply( console, arguments );
    }
}

// Dustin Diaz - $script.js
Factlink.util.domReady = function(fn) {
    /in/.test( document['readyState'] ) ? setTimeout( function() { domReady(fn); }, 50) : fn();
};

// Expose the Factlink object to the global object
return Factlink;

})();