FactlinkApp.scrollToTopInitializer = (options) ->
  Backbone.history.on 'route', ->
    $(window).scrollTop 0
