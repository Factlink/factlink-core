FactlinkJailRoot.scrollTo = (fact_id) ->

  scrolled = false
  scroll = ->
    return if scrolled
    return if $("span[data-factid=#{fact_id}]").length <= 0
    scrolled = true

    scrollTop = $("span[data-factid=#{fact_id}]").offset().top
    scrollTop -= $(window).height()/2 - 100
    $('html, body').animate {scrollTop}, 800

  scroll()
  FactlinkJailRoot.on 'factlink.factsLoaded', scroll
