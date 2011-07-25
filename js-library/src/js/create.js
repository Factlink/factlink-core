(function( Factlink ) {
// Function which will return the Selection object
//@TODO: Add rangy support for IE
function getTextRange(){
    var d = '';
    if (window.getSelection) {
        d = window.getSelection()
    } else {
        if (document.getSelection) {
            d = document.getSelection()
        } else if (document.selection) {
            d = document.selection.createRange().text
        }
    }
    return d;
};

// Prepare a new Factlink
function prepare(rng, passage, top, left) {
    // Prepare the Factlink on the remote
    Factlink.remote.prepareNewFactlink( rng.toString(), 
                                        passage, 
                                        window.location.href );
    
    // Position the frame
    Factlink.remote.position( top, left  );
    Factlink.modal.show.method();
};

// We make this a global function so it can be used for direct adding of facts
// (Right click with chrome-extension)
Factlink.getSelectionInfo = function() {
    // Get the selection object
    var selection = getTextRange();

    // TODO Add passage detection here
    
    return {
        range: selection,
        passage: ""
    };
};

// Bind the actual selecting
$( 'body' ).bind('mouseup', function(e) {
    // If there is an active timeout
    if ( Factlink.timeout ) {
        // Clear it!
        window.clearTimeout( Factlink.timeout );
    }
    
    // Retrieve all needed info of current selection
    var selectionInfo = Factlink.getSelectionInfo();
    // Get the selection object
    var selection = selectionInfo.range;
    // Retrieve the text from the selection
    var text = selection.toString();
    
    // Check if the selected text is long enough to be added
    if ( text !== undefined && text.length > 1 && selection.rangeCount > 0 ) {
        // Store the time out
        Factlink.timeout = setTimeout(function() {
            // Retrieve all needed info of current selection
            var selectionInfo = Factlink.getSelectionInfo();
            // Make sure the text is still selected
            var selection = selectionInfo.range;
            
            if (selection.rangeCount > 0) {
                prepare(selection.getRangeAt(0), 
                        selectionInfo.passage, 
                        e.clientY, 
                        e.clientX);
            }
        }, 500);
    }
});
})( window.Factlink );