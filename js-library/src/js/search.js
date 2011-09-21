(function(Factlink) {
  // Function to search the page
  Factlink.search = function(searchString) {
    var document = window.document,
        alert = window.alert,
        // Array which will hold all the results
        results = [],
        // Store scroll settings to reset to afterwards
        scrollTop = document.body.scrollTop,
        scrollLeft = document.body.scrollLeft,
        
        selection, range, selectedRange;

    if (window.find) { // Chrome, Firefox, Safari
      // Reset the selection
      selection = window.getSelection();

      // If the user currently has selected some text
      if (selection.rangeCount > 0) {
        // Store the selection
        selectedRange = selection.getRangeAt(0);
      }

      window.getSelection().removeAllRanges();

      // Loop through all the results of the search string
      while (window.find(searchString, false)) {
        selection = window.getSelection();
        range = selection.getRangeAt(0);

        // Add the range to the results
        results.push(range);
      }

      // Reset the selection
      window.getSelection().removeAllRanges();

      if (selectedRange !== undefined) {
        window.getSelection().addRange(selectedRange);
      }
    } else { // No window.find
      return false;
    }

    // Scroll back to previous location
    window.scroll(scrollLeft, scrollTop);

    return results;
  };
})(window.Factlink);
