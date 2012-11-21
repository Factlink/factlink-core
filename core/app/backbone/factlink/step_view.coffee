Backbone.Factlink ||= {}
class Backbone.Factlink.StepView extends Backbone.Marionette.CompositeView
  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate"

  constructor: (args...)->
    super(args...)

    @on 'activate', @activate, this
    @on 'deactivate', @deactivate, this

  deactivate: -> @$el.removeClass 'active'
  activate: -> @$el.addClass 'active'


  scrollIntoView: -> scrollIntoViewWithinContainer(@el, @$el)
