(function( Factlink, waitingCount ) {
    if ( Factlink !== undefined ) {
        var selectionInfo = Factlink.getSelectionInfo();
        
        // Get al the facts on the current page
        Factlink.remote.createFactlink(selectionInfo.text, 
                                       selectionInfo.passage, 
                                       window.location.href,
                                       FactlinkConfig.modus);
        
        Factlink.modal.show.method();
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