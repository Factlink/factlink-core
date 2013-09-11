scrollTo = (fact_id) ->
  $('body')
    ._scrollable()
    .scrollTo "span[data-factid=#{fact_id}]", 800,
      offset:
        top:-100
        axis: 'y'

$(window).bind 'factlink.factsLoaded', ->
  scrollTo FactlinkConfig.scrollto if FactlinkConfig?.scrollto?
