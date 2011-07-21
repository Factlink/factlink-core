(function( Factlink ) {
// Function to search the page
Factlink.search = function(searchString){
	var document = window.document,
		alert = window.alert,
		// Array which will hold all the results
		results = [],
    
        // Store scroll settings to reset to afterwards
        scrollTop = document.body.scrollTop,
        scrollLeft = document.body.scrollLeft,
        
        rangy = window.rangy,
        selection, range, ierange, scroll;
    
    if ( window.find ) { // Chrome, Firefox, Safari
        // Reset the selection
        // Maybe we later need to store the current selection before 
        // processing the document, so we can reset it afterwards
        window.getSelection().removeAllRanges();
        
        // Loop through all the results of the search string
        while ( window.find(searchString, false) ) {
            selection = window.getSelection();
            range = selection.getRangeAt(0);

            // Add the range to the results
            results.push(range);
        }

        // Reset the selection
        // Maybe we later need to store the current selection before 
        // processing the document, so we can reset it afterwards
        window.getSelection().removeAllRanges();
    } else { // No window.find and createTextRange
        return false;
    }
    
    // Scroll back to previous location
    window.scroll(scrollLeft,scrollTop);
        
    return results;
};
})( window.Factlink );