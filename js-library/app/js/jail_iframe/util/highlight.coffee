ensureScrollSaved = (func) ->
  try
    # Store scroll settings to reset to afterwards
    scrollTop = window.document.body.scrollTop
    scrollLeft = window.document.body.scrollLeft
    func()
  finally
    # Scroll back to previous location
    window.scroll scrollLeft, scrollTop

ensureSelectionSaved = (func) ->
  oldRanges = []
  try
    # If the user currently has selected some text, store the selection
    selection = window.document.getSelection()
    oldRanges =
      for i in [0...selection.rangeCount]
        selection.getRangeAt(i)
    func()
  finally
    # Reset the selection
    window.document.getSelection().removeAllRanges()

    # Restore previous selection
    for selectedRange in oldRanges
      window.document.getSelection().addRange selectedRange


# Chrome, Firefox, Safari
searchWithWindowFind = (searchString) ->

  selection = window.document.getSelection()
  # Reset the selection
  selection.removeAllRanges()

  # Loop through all the results of the search string
  results = []
  while window.find(searchString, false)
    results.push selection.getRangeAt(0)

  results

searchWithFindText = (searchString) -> #IE
  searchRange = window.document.body.createTextRange()
  searchRange.collapse()
  selection = window.document.getSelection()
  # Loop through all the results of the search string
  results = []
  while searchRange.findText(searchString, 1000000000, 4)
    #WTF: findText API is crazy http://msdn.microsoft.com/en-us/library/ms536422.aspx
    #second parameter must be "large" ????
    try
      searchRange.select() # select may fail if text is "unselectable" such as a script tag.
      results.push selection.getRangeAt(0)
    catch
    searchRange.collapse(false) # move degenerate range aka cursor to end of match

  results


searchAlgorithm =
  if window.find
    searchWithWindowFind
  else
    searchWithFindText

# Function to search the page
search = (searchString) ->
  ensureScrollSaved ->
    ensureSelectionSaved ->
      searchAlgorithm(searchString.trim())


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


# Function to select the found ranges
FactlinkJailRoot.highlightFact = (text, id) ->
  ranges = search(text)


  for range in ranges
    normalizedRange = new FactlinkJailRoot.Range.BrowserRange(range).normalize()
    elements = highlightRange(normalizedRange, id)

    if elements.length > 0
      new FactlinkJailRoot.Highlight(id, elements)
    else
      console.error "Could not highlight, empty factlink or complete overlap? Text: <#{text}>"

highlightFacts = (facts_data) ->
  # If there are multiple matches on the page, loop through them all
  for fact_data in facts_data
    FactlinkJailRoot.highlightFact(fact_data.displaystring, fact_data.id)

  FactlinkJailRoot.trigger "factlink.factsLoaded", facts_data
  FactlinkJailRoot.perf.add_timing_event 'facts highlighted'


# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = (siteUrl) ->
  FactlinkJailRoot.perf.add_timing_event 'fetchFacts:start'
  $.ajax
    # The URL to the FactlinkJailRoot backend
    url: FactlinkJailRoot.apiBaseUri() + "/site?url=" + encodeURIComponent(siteUrl)
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"
    success: -> FactlinkJailRoot.perf.add_timing_event 'fetchFacts:done'

facts_promise = null
initial_fetch_facts_url = null

FactlinkJailRoot.jail_ready_promise.done ->
  initial_fetch_facts_url = FactlinkJailRoot.siteUrl()
  facts_promise = fetchFacts initial_fetch_facts_url

FactlinkJailRoot.host_ready_promise.done ->
  console.info "FactlinkJailRoot:", "startHighlighting"

  if initial_fetch_facts_url != FactlinkJailRoot.siteUrl()
    # Somewhere in the document a <link rel="canonical"> appeared in the meantime
    facts_promise.abort()
    facts_promise = fetchFacts FactlinkJailRoot.siteUrl()

  facts_promise.done(highlightFacts)

# Don't check for highlighting here, as this is a
# special hacky-patchy method for in the blog
FactlinkJailRoot.highlightAdditionalFactlinks = (siteUrl) ->
  console.info "FactlinkJailRoot:", "highlightAdditionalFactlinks"
  fetchFacts(siteUrl).done(highlightFacts)
