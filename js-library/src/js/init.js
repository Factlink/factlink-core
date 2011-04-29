(function( Factlink ) {
    if ( Factlink.util !== undefined ) {        
        // Get al the facts on the current page
        Factlink.getTheFacts();
        
        Factlink.overlay = $( '<div id="factlink-overlay" />' ).appendTo('body');
        
        Factlink.overlay.bind('click', function() {
            Factlink.iframe.remove();
            $( this ).hide();
        });
    } else {
        setTimeout( function() {
            arguments.callee(Factlink);
        }, 10);
    }
})( window.Factlink );