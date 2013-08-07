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
      @listenTo FactlinkApp.vent, 'controller:switch', @closeController
      @openController() unless @started
      @onAction?()
      @[name](args...)

  openController: ->
    FactlinkApp.vent.trigger 'controller:switch'
    @started = true
    @onShow() if @onShow?

  closeController: ->
    @stopListening()
    @started = false
    @onClose() if @onClose?

Backbone.Factlink.BaseController.extend = Backbone.View.extend
