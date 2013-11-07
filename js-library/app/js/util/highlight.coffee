Factlink.Facts = []

# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = (siteUrl=Factlink.siteUrl()) ->
  # The URL to the Factlink backend
  src = FactlinkConfig.api + "/site?url=" + encodeURIComponent(siteUrl)

  $.ajax
    url: src
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"

highlighting = false

Factlink.startHighlighting = ->
  return if highlighting
  highlighting = true

  console.info "Factlink:", "startHighlighting"
  fetchFacts().done (facts_data) ->
    # If there are multiple matches on the page, loop through them all
    for fact_data in facts_data
      # Select the ranges (results)
      ranges = Factlink.search(fact_data.displaystring)
      $.merge Factlink.Facts, Factlink.selectRanges(ranges, fact_data.id)

    Factlink.trigger "factlink.factsLoaded", facts_data

# Don't check for highlighting here, and also don't trigger, as this is a
# special hacky-patchy method for in the blog
Factlink.highlightAdditionalFactlinks = (siteUrl) ->
  console.info "Factlink:", "highlightAdditionalFactlinks"
  fetchFacts(siteUrl).done (facts_data) ->
    # If there are multiple matches on the page, loop through them all
    for fact_data in facts_data
      # Select the ranges (results)
      ranges = Factlink.search(fact_data.displaystring)
      $.merge Factlink.Facts, Factlink.selectRanges(ranges, fact_data.id)

Factlink.stopHighlighting = ->
  return unless highlighting
  highlighting = false

  console.info "Factlink:", "stopHighlighting"
  fact.destroy() for fact in Factlink.Facts
  Factlink.Facts = []
