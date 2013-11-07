Factlink.Facts = []

highlightFacts = (facts_data) ->
  # If there are multiple matches on the page, loop through them all
  for fact_data in facts_data
    # Select the ranges (results)
    ranges = Factlink.search(fact_data.displaystring)
    $.merge Factlink.Facts, Factlink.selectRanges(ranges, fact_data.id)

  Factlink.trigger "factlink.factsLoaded", facts_data

# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = (siteUrl=Factlink.siteUrl()) ->
  $.ajax
    # The URL to the Factlink backend
    url: FactlinkConfig.api + "/site?url=" + encodeURIComponent(siteUrl)
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"
    success: highlightFacts

highlighting = false
Factlink.startHighlighting = ->
  return if highlighting
  highlighting = true

  console.info "Factlink:", "startHighlighting"
  fetchFacts()

# Don't check for highlighting here, as this is a
# special hacky-patchy method for in the blog
Factlink.highlightAdditionalFactlinks = (siteUrl) ->
  console.info "Factlink:", "highlightAdditionalFactlinks"
  fetchFacts()

Factlink.stopHighlighting = ->
  return unless highlighting
  highlighting = false

  console.info "Factlink:", "stopHighlighting"
  fact.destroy() for fact in Factlink.Facts
  Factlink.Facts = []
