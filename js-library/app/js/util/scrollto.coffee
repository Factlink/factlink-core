Factlink.scrollTo = (fact_id) ->
  $('body')
    ._scrollable()
    .scrollTo "span[data-factid=#{fact_id}]", 800,
      offset:
        top:-100
        axis: 'y'

Factlink.on 'factlink.factsLoaded', ->
  if FactlinkConfig.scrollto?
    Factlink.scrollTo FactlinkConfig.scrollto
  else if FactlinkConfig.openFactlinkId?
    Factlink.scrollTo FactlinkConfig.openFactlinkId
