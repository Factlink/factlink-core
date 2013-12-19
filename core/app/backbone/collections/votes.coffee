class window.Votes extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @_fact_id = options.fact.id

  url: ->
    "/facts/#{@_fact_id}/opinionators"
