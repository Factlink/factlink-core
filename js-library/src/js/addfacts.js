// this is a script called from the extension
(function( Factlink, waitingCount ) {
    if ( Factlink !== undefined ) {
		Factlink.addSelection()
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