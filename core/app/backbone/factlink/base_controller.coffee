Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController

  constructor: (args...)->
    Backbone.Marionette.addEventBinder @

    @initializeRoutes(@routes)
    @initialize(args...) if @initialize?

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) ->
    (args...) ->
      @openController() unless @started
      @onAction?()
      @[name](args...)

  openController: ->
    FactlinkApp.vent.trigger 'controller:switch'
    @listenTo FactlinkApp.vent, 'controller:switch', @closeController
    @started = true
    @onShow() if @onShow?

  closeController: ->
    @unbindAll()
    @started = false
    @onClose() if @onClose?

Backbone.Factlink.BaseController.extend = Backbone.View.extend
