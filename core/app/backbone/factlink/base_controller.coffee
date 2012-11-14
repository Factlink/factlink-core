Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController
  constructor: (args...)->
    eventBinder = new Backbone.Marionette.EventBinder()
    _.extend(@, eventBinder)
    @initializeRoutes(@routes)
    @initialize(args...) if @initialize?

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) ->
    (args...) ->
      @showController()
      @[name](args...)

  showController: ->
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
