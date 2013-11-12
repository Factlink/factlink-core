Factlink.scrollTo = (fact_id) ->

  scrolled = false
  scroll = ->
    return if scrolled
    return if $("span[data-factid=#{fact_id}]").length <= 0
    scrolled = true

    $('body')
      ._scrollable()
      .scrollTo "span[data-factid=#{fact_id}]", 800,
        offset:
          top: -100
          axis: 'y'


  scroll()
  Factlink.on 'factlink.factsLoaded', scroll
