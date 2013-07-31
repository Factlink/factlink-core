class window.OpinionatersCollection extends Backbone.Factlink.Collection
  model: OpinionatersEvidence

  default_fetch_data:
    take: 7

  initialize: (models, options) ->
    @fact = options.fact

    @_wheel = @fact.getFactWheel()
    @_wheel.on 'sync', =>
      @fetch()

  url: ->
    "/facts/#{@fact.id}/interactors"

  fetch: (options={}) ->
    options = _.clone options
    options.data = _.extend {}, @default_fetch_data, options.data || {}
    super options
