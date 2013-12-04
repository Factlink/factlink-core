FactlinkApp.scrollToTopInitializer = () ->
  Backbone.history.on 'route', ->
    $(window).scrollTop 0
