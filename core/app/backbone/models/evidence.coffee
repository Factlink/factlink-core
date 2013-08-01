class window.Evidence extends Backbone.Model
  toJSON: ->
    _.extend super(),
      formatted_impact: format_as_short_number(@get('impact'))
      positive_impact: @get('impact') >= 0
