class window.Wheel extends Backbone.Model
  initialize: -> @opinionTypes = new OpinionTypes(@get("opinion_types"))

  toJSON: ->
    originalAttributes = super()
    _.extend({},originalAttributes,
      opinion_types: @opinionTypes.toJSON()
    )
