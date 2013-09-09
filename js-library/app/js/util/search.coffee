# Chrome, Firefox, Safari
searchWithWindowFind = (searchString) ->
  # If the user currently has selected some text, store the selection
  selection = window.document.getSelection()
  selectedRange = selection.getRangeAt(0) if selection.rangeCount > 0

  # Reset the selection
  window.document.getSelection().removeAllRanges()

  # Loop through all the results of the search string
  results = []
  while window.find(searchString, false)
    selection = window.document.getSelection()
    results.push selection.getRangeAt(0)

  # Reset the selection
  window.document.getSelection().removeAllRanges()

  # Restore previous selection
  window.document.getSelection().addRange selectedRange if selectedRange?

  results

# Function to search the page
FACTLINK.search = (searchString) ->
  return false unless window.find?

  # Store scroll settings to reset to afterwards
  scrollTop = window.document.body.scrollTop
  scrollLeft = window.document.body.scrollLeft

  results = searchWithWindowFind(searchString)

  # Scroll back to previous location
  window.scroll scrollLeft, scrollTop

  results
