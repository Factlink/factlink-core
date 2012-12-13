Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController

  constructor: (args...)->
    Marionette.addEventBinder(this);

    @initializeRoutes(@routes)
    @initialize(args...) if @initialize?

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) ->
    (args...) ->
      @openController()
      @onAction() if @onAction?
      @[name](args...)

  openController: ->
    return if @started
    FactlinkApp.vent.trigger 'controller:switch'
    @bindTo FactlinkApp.vent, 'controller:switch', @closeController, this
    @started = true
    @onShow() if @onShow?

  closeController: ->
    @unbindAll()
    @started = false
    @onClose() if @onClose?

Backbone.Factlink.BaseController.extend = Backbone.View.extend
