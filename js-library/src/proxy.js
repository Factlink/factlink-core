(function( Factlink ) {
// Function which will make sure all the links on the current page will 
// be set so that Factlink will proxy them
Factlink.prototype.initProxy = function(){
    // We can only start manipulating when the DOM is fully loaded
    Factlink.utils.domReady(function(){
            // Get all the A tags on the current page
        var a = document.getElementsByTagName("a");

        for ( var i = 0, j = a.length; i < j; i++ ) {
                // Store the current tag
            var b = a[i];
            var href = b.href;
                // Is the href a valid one which needs to be proxied?
            var valid = false;
            
            // TODO: We need to make sure to capture links without href attributes
            //       (onclick=window.open('test.html'))
            
            // Check to make sure we have a valid href
            // TODO: This statement needs a lot of refactoring and overthinking,
            //       We should be able to detect location changes in javascript:
            //       links.
            if ( href.length > 0 ) {
                // Does the href start with http:// ?
                if ( href.search(/http:\/\//) !== 0 ) { 
                    if ( href.search(/mailto:/) !== 0 && 
                         href.search(/javascript:/) !== 0 ) {
                        window.console.info( "N: " + href );
                    }
                } else {
                    valid = true;
                }
            }
            
            // Only change the href when we have a valid link
            if ( valid ) {
                b.href = href.replace(/^http:\/\//, 'http://fct.li:8080/s/http://');
            }
        }
    });
};    
})( Factlink );