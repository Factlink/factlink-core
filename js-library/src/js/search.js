(function(Factlink, $, _, easyXDM, window, undefined) {
  // Function to search the page
  Factlink.search = function(searchString) {
    var document = window.document,
        alert = window.alert,
        // Array which will hold all the results
        results = [],
        // Store scroll settings to reset to afterwards
        scrollTop = window.document.body.scrollTop,
        scrollLeft = window.document.body.scrollLeft,

        selection, range, selectedRange;

    if (window.find) { // Chrome, Firefox, Safari
      // Reset the selection
      selection = window.document.getSelection();

      // If the user currently has selected some text
      if (selection.rangeCount > 0) {
        // Store the selection
        selectedRange = selection.getRangeAt(0);
      }

      window.document.getSelection().removeAllRanges();

      // Loop through all the results of the search string
      while (window.find(searchString, false)) {
        selection = window.document.getSelection();
        range = selection.getRangeAt(0);

        // Add the range to the results
        results.push(range);
      }

      // Reset the selection
      window.document.getSelection().removeAllRanges();

      if (selectedRange !== undefined) {
        window.document.getSelection().addRange(selectedRange);
      }
    } else { // No window.find
      return false;
    }

    // Scroll back to previous location
    window.scroll(scrollLeft, scrollTop);

    return results;
  };
})(window.Factlink, Factlink.$, Factlink._, Factlink.easyXDM, Factlink.global);
