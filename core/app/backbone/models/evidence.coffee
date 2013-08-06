class window.Evidence extends Backbone.Model
  toJSON: ->
    _.extend super(),
      formatted_impact: format_as_short_number(@get('impact'))
      positive_impact: @positiveImpact()

  positiveImpact: -> @get('impact') >= 0
