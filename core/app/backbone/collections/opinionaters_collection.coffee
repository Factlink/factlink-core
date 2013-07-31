class window.OpinionatersCollection extends Backbone.Factlink.Collection
  model: OpinionatersEvidence

  default_fetch_data:
    take: 7

  initialize: (models, options) ->
    @_fact_id = options.fact.id

    wheel = options.fact.getFactWheel()
    wheel.on 'sync', =>
      @fetch()

  fact_id: -> @_fact_id

  url: ->
    "/facts/#{@_fact_id}/interactors"

  fetch: (options={}) ->
    options = _.clone options
    options.data = _.extend {}, @default_fetch_data, options.data || {}
    super options
