Factlink.Facts = []

# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = ->
  # The URL to the Factlink backend
  src = FactlinkConfig.api + "/site?url=" + encodeURIComponent(Factlink.siteUrl())

  $.ajax
    url: src
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"

Factlink.startHighlighting = ->
  console.info "Factlink:", "startHighlighting"
  fetchFacts().done (facts_data) ->
    # If there are multiple matches on the page, loop through them all
    for fact_data in facts_data
      # Select the ranges (results)
      ranges = Factlink.search(fact_data.displaystring)
      $.merge Factlink.Facts, Factlink.selectRanges(ranges, fact_data.id)

    Factlink.trigger "factlink.factsLoaded"

Factlink.stopHighlighting = ->
  console.info "Factlink:", "stopHighlighting"
  fact.destroy() for fact in Factlink.Facts
  Factlink.Facts = []
