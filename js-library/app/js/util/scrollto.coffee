Factlink.scrollTo = (fact_id) ->

  Factlink.onLoaded 'factlink.factsLoaded', ->

    if $("span[data-factid=#{fact_id}]").length <= 0
      console?.error? "Factlink: Could not scroll to non-existing fact_id: #{fact_id}"
      return

    $('body')
      ._scrollable()
      .scrollTo "span[data-factid=#{fact_id}]", 800,
        offset:
          top:-100
          axis: 'y'
