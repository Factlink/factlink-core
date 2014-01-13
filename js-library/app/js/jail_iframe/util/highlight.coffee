trim = (string) -> string.replace(/^\s+|\s+$/g, '');

# Chrome, Firefox, Safari
searchWithWindowFind = (searchString) ->
  # Trim
  searchString = trim(searchString);

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
search = (searchString) ->
  return false unless window.find?

  # Store scroll settings to reset to afterwards
  scrollTop = window.document.body.scrollTop
  scrollLeft = window.document.body.scrollLeft

  results = searchWithWindowFind(searchString)

  # Scroll back to previous location
  window.scroll scrollLeft, scrollTop

  results

# Adapted from https://github.com/okfn/annotator/blob/master/src/annotator.coffee
highlightNode = (node, id) ->
  # Ignore text nodes that contain only whitespace characters. This prevents
  # spans being injected between elements that can only contain a restricted
  # subset of nodes such as table rows and lists. This does mean that there
  # may be the odd abandoned whitespace node in a paragraph that is skipped
  # but better than breaking table layouts.
  return if /^\s*$/.test(node.nodeValue)

  # Don't re-wrap nodes that have been wrapped already
  $node = $(node)
  return if $node.parent().hasClass 'factlink'

  $highlight = $("<span class='factlink'></span>")
  $highlight.attr 'data-factid', id

  $node.wrapAll($highlight).parent().show()[0]

highlightRange = (normalizedRange, id) ->
  elements = []
  for node in normalizedRange.textNodes()
    element = highlightNode(node, id)
    elements.push element if element?
  elements

FactlinkJailRoot.highlightsByFactIds = {}

# Function to select the found ranges
FactlinkJailRoot.highlightFact = (text, id) ->
  ranges = search(text)

  FactlinkJailRoot.highlightsByFactIds[id] ?= []

  for range in ranges
    normalizedRange = new FactlinkJailRoot.Range.BrowserRange(range).normalize()
    elements = highlightRange(normalizedRange, id)
    FactlinkJailRoot.highlightsByFactIds[id].push new FactlinkJailRoot.Highlight(id, elements)

highlightFacts = (facts_data) ->
  # If there are multiple matches on the page, loop through them all
  for fact_data in facts_data
    FactlinkJailRoot.highlightFact(fact_data.displaystring, fact_data.id)

  FactlinkJailRoot.trigger "factlink.factsLoaded", facts_data

# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = (siteUrl) ->
  $.ajax
    # The URL to the FactlinkJailRoot backend
    url: FactlinkConfig.api + "/site?url=" + encodeURIComponent(siteUrl)
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"
    success: highlightFacts

highlighting = false
FactlinkJailRoot.startHighlighting = ->
  return if highlighting
  highlighting = true
  FactlinkJailRoot.initializeFactlinkButton()

  console.info "FactlinkJailRoot:", "startHighlighting"
  fetchFacts FactlinkJailRoot.siteUrl()

# Don't check for highlighting here, as this is a
# special hacky-patchy method for in the blog
FactlinkJailRoot.highlightAdditionalFactlinks = (siteUrl) ->
  console.info "FactlinkJailRoot:", "highlightAdditionalFactlinks"
  fetchFacts siteUrl
