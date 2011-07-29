(function( Factlink, waitingCount ) {
    if ( Factlink !== undefined ) {
        // Get al the facts on the current page
        Factlink.getTheFacts();
        
        // Get the template which holds the indication of each factlink
        // and is shown when the user hovers a Factlink
        $.ajax({
            method: 'get',
            dataType: 'jsonp',
            crossDomain: true,
            url: FactlinkConfig.api + 'factlink/indication.js',
            success: function( data ) {
                Factlink.Indicator.setElement( $( data ).attr('id','factlink-indicator').appendTo('body') );
            }
        });
    } else {
        // Store arguments object so we can use from the setTimeout and loadFactlink
        var arg = arguments;
        
        // If it takes longer then 5 seconds we just stop
        // TODO maybe some error message here?
        if ( waitingCount >= 50 ) {
            return;
        }
        
        setTimeout(function(){
            arg.callee(Factlink, ++waitingCount);
        }, 100);
    }
})( window.Factlink, 0 );