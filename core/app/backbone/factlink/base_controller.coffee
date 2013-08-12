Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController extends Backbone.Marionette.Controller

  constructor: ->
    @initializeRoutes(@routes)
    super

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) ->
    (args...) ->
      @stopListening()
      @openController() unless @started
      @listenTo FactlinkApp.vent, 'controller:switch', @closeController
      @onAction?()
      @[name](args...)

  # CONSIDER THIS DEPRECATED, as it is only used by CachingController, which is deprecated
  openController: ->
    FactlinkApp.vent.trigger 'controller:switch'
    @started = true
    @onShow() if @onShow?

  # CONSIDER THIS DEPRECATED, as it is only used by CachingController, which is deprecated
  closeController: ->
    @stopListening()
    @started = false
    @onClose() if @onClose?

Backbone.Factlink.BaseController.extend = Backbone.View.extend
