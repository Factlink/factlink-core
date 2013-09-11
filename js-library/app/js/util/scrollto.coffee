scrollTo = (fact_id) ->
  $('body')
    ._scrollable()
    .scrollTo "span[data-factid=#{fact_id}]", 800,
      offset:
        top:-100
        axis: 'y'

Factlink.on 'factlink.factsLoaded', ->
  return unless FactlinkConfig.scrollto?

  scrollTo FactlinkConfig.scrollto
