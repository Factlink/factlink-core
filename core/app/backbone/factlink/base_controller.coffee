Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController

  constructor: (args...)->
    eventBinder = new Backbone.Marionette.EventBinder()
    _.extend(@, eventBinder)
    # When updating Marionette:
    # Use this instead of the above as soon as @janpaul123's pull request is merged into a new version
    # Backbone.Marionette.addEventBinder @

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
    @bindTo FactlinkApp.vent, 'controller:switch', @closeController, this
    @started = true
    @onShow() if @onShow?

  closeController: ->
    @unbindAll()
    @started = false
    @onClose() if @onClose?

Backbone.Factlink.BaseController.extend = Backbone.View.extend
