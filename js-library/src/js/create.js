(function( Factlink ) {
// Make the user able to add a Factlink
Factlink.submitFact = function(){
    var selection = window.getSelection();
    
    if ( window.rangy !== undefined ) {
        selection = window.rangy.getSelection();
    }
    
    try {
        // Get the selected text
        var range = selection.getRangeAt(0);
    } catch(e) {
        alert("bam");
        // Possibly the user didn't select anything
        return false;
    }
    
    if (range.toString().length < 1) {
        //@TODO: Fix the loader
        // Tell the loader we're done
        // FL.Loader.finish();
        
        // Return to make the function stop
        return false;
    }
    
    $.ajax({
        url: Factlink.conf.api.loc + '/factlink/new',
        dataType: 'jsonp',
        crossDomain: true,
        jsonp: "callback",
        type: 'post',
        data: {
            url: window.location.href,
            fact: range.toString()
        }
    }).success(function(data) {
        if (data.status === true) {
            // Select the selected text
            Factlink.selectRanges([range]);
            
            //@TODO: Fix the loader
            // The loader can hide itself
            // FL.Loader.finish();
        } else {
            //@TODO: Better errorhandling
            alert("Something went wrong");
            
            //@TODO: Fix the loader
            // The Loader can hide itself
            // FL.Loader.finish();
        }
    }).error(function(data) {
        //@TODO: Fix the loader
        //TODO: Better errorhandling
        // FL.Loader.finish();
    });
};

// Track user selection change
var sel = null,
    sel_text = null,
    min_len = 10,
    // Function which will return the Selection object
    //@TODO: Add rangy support for IE
    getText = function(){
        if (window.getSelection) {
            var d = window.getSelection()
        } else {
            if (document.getSelection) {
                var d = document.getSelection()
            } else {
                if (document.selection) {
                    var d = document.selection.createRange().text
                } else {
                    return '';
                }
            }
        }
        return d;
    };

// Bind the actual selecting
$( 'body' ).bind('mouseup', function(e) {
    // Get the selection object
    sel = getText();
    // Retrieve the text from the selection
    sel_text = sel.toString();
    
    // Hide all the (possible) open Factlink windows
    try {
        Factlink.modal.frame.remove();
        Factlink.modal.frame = null;
        Factlink.overlay.hide();
    } catch (e) {}
    
    // Check if the selected text is long enough to be added
    if ( sel_text !== null && sel_text.length > min_len && sel.rangeCount > 0 ) {
        // Store the time out
        Factlink.timeout = setTimeout(function() {
            Factlink.startSubmitting(sel.getRangeAt(0), e.pageY, e.pageX);
        }, 500);
    }
});

Factlink.startSubmitting = function(rng, top, left) {
    // Prepare the Factlink on the remote
    Factlink.remote.prepareNewFactlink( rng.toString(), 
                                        "NotImplemented", 
                                        window.location.href );
                                        
    // Position the frame
    Factlink.modal.positionFrame.method( top, left  );
    Factlink.modal.showFrame.method();
};
})( window.Factlink );