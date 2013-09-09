FACTLINK.Facts = []

# Function which will collect all the facts for the current page
# and select them.
# Returns deferred object
fetchFacts = ->
  # The URL to the Factlink backend
  src = FactlinkConfig.api + "/site?url=" + encodeURIComponent(FACTLINK.siteUrl())

  $.ajax
    url: src
    dataType: "jsonp"
    crossDomain: true
    type: "GET"
    jsonp: "callback"

FACTLINK.startHighlighting = ->
  console.info "FACTLINK:", "startHighlighting"
  fetchFacts().done (facts_data) ->
    # If there are multiple matches on the page, loop through them all
    for fact_data in facts_data
      # Select the ranges (results)
      ranges = FACTLINK.search(fact_data.displaystring)
      $.merge FACTLINK.Facts, FACTLINK.selectRanges(ranges, fact_data.id)

    $(window).trigger "FACTLINK.factsLoaded"

FACTLINK.stopHighlighting = ->
  console.info "FACTLINK:", "stopHighlighting"
  fact.destroy() for fact in FACTLINK.Facts
  FACTLINK.Facts = []
