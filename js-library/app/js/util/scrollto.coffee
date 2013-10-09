Factlink.scrollTo = (fact_id) ->
  $('body')
    ._scrollable()
    .scrollTo "span[data-factid=#{fact_id}]", 800,
      offset:
        top:-100
        axis: 'y'
