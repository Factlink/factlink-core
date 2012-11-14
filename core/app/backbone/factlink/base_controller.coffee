Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController
  constructor: (args...)->
    @initializeRoutes(@routes)
    @initialize(args...) if @initialize?

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) ->
    (args...) ->
      @startController()
      @[name](args...)

  startController: ->
    return if @started
    FactlinkApp.vent.trigger 'switched_controller'
    FactlinkApp.vent.on 'switched_controller', =>
      FactlinkApp.vent.off 'switched_controller'
      @started = false
      @onClose() if @onClose?
    @started = true
    @onShow() if @onShow?
