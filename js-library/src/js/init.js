(function( Factlink ) {
    if ( Factlink !== undefined ) {
        // Get the template which holds the indication of each factlink
        // and is shown when the user hovers a Factlink
        $.ajax({
            method: 'get',
            dataType: 'jsonp',
            crossDomain: true,
            url: Factlink.conf.api.loc + '/factlink/indication.js',
            success: function( data ) {
                // Get al the facts on the current page
                Factlink.getTheFacts();
                
                Factlink.Indicator.setElement( $( data ).attr('id','factlink-indicator').appendTo('body') );

                Factlink.overlay = $( '<div id="factlink-overlay" />' ).appendTo('body');
            }
        });
    } else {
        setTimeout( function() {
            arguments.callee(Factlink);
        }, 10);
    }
})( window.Factlink );