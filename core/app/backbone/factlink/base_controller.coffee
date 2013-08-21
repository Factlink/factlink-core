Backbone.Factlink ||= {}
class Backbone.Factlink.BaseController extends Backbone.Marionette.Controller

  constructor: ->
    @initializeRoutes(@routes)
    super

  initializeRoutes: (routes) ->
    for route in routes
      functionName = "on#{route.capitalize()}"
      @[functionName] = @getRouteFunction(route)

  getRouteFunction: (name) -> @[name]

Backbone.Factlink.BaseController.extend = Backbone.View.extend
