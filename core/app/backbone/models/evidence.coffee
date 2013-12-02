class window.Evidence extends Backbone.Model
  positiveImpact: -> @get('impact') >= 0

  toJSON: ->
    _.extend super(),
      formatted_impact: format_as_short_number(@get('impact'))
