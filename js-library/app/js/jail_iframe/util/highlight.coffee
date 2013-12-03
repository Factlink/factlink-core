highlightFacts = (facts_data) ->
  # If there are multiple matches on the page, loop through them all
  for fact_data in facts_data
    # Select the ranges (results)
    ranges = FactlinkJailRoot.search(fact_data.displaystring)
    FactlinkJailRoot.selectRanges(ranges, fact_data.id)

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
