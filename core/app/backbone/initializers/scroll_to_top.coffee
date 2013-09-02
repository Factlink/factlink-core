FactlinkApp.scrollToTopInitializer = (options) ->
  FactlinkApp.vent.on 'load_url', ->
    $(window).scrollTop 0
