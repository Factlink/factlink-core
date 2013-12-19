class window.OpinionatorsCollection extends Backbone.Factlink.Collection
  model: OpinionatorsEvidence

  initialize: (models, options) ->
    @_fact_id = options.fact_id

  url: ->
    "/facts/#{@_fact_id}/opinionators"
