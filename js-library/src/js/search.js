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
    } else if (document.body.createTextRange) { // IE & Opera
            // Create an empty range object
        range = document.body.createTextRange();
        
        if ( range.findText ) { // IE
            // IE8 Doesn't support search over multiple elements...
            if (document.documentMode && document.documentMode === 8) { // IE8
                alert( "Your browser is currently running in IE8 Mode, this rendering " +
                       "mode of IE8 has a bug which may cause Factlink from not finding " + 
                       "all the available Factlinks on this page.");
            } 

            while ( range.findText(searchString) ) {
                // We need to encapsulate the following statements in a try-catch
                // because IE will throw an error (800a025e) when trying to select
                // a non-visible range
                // TODO: Find out if we can surpass this by using the internal rangy
                //       functions which will parse a normal range into a rangy-range
                try {
                    // Select the current range, necessary because of the ierange 
                    // we're using
                    range.select();
                    
                        // Because of IE's shitty implementation of the Range and 
                        // Selection objects, we have to refresh the range (this 
                        // time the rangy module is used)
                    selection = rangy.getSelection();

                        // the rangy object
                    ierange = selection.getRangeAt(0);

                    // Push the range to the results
                    results.push(ierange);

                    // Move on
                    range.collapse(false);
                    selection.removeAllRanges();
                } catch (e) {
                    // We need to collapse the range because otherwise IE will 
                    // keep matching this range
                    range.collapse(false);
                }
            }
        } else { // Opera
            alert( "Your browser is currently not supported by Factlink" );
        }
    } else { // No window.find and createTextRange
        alert( "Unimplemented" );
    }
    
    // Scroll back to previous location
    window.scroll(scrollLeft,scrollTop);
        
    return results;
};
})( window.Factlink );