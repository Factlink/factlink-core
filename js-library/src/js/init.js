(function( Factlink ) {
    if ( Factlink !== undefined ) {        
        // Get al the facts on the current page
        Factlink.getTheFacts();
        
        Factlink.overlay = $( '<div id="factlink-overlay" />' ).appendTo('body');
    } else {
        setTimeout( function() {
            arguments.callee(Factlink);
        }, 10);
    }
})( window.Factlink );