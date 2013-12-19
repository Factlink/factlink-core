class window.OpinionatorsCollection extends Backbone.Factlink.Collection
  model: OpinionatorsEvidence

  default_fetch_data:
    take: 1000000 # TODO: remove when removed in backend

  initialize: (models, options) ->
    @_fact_id = options.fact_id

  url: ->
    "/facts/#{@_fact_id}/interactors"

  fetch: (options={}) ->
    options = _.clone options
    options.data = _.extend {}, @default_fetch_data, options.data || {}
    super options
