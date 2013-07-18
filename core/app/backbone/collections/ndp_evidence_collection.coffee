class window.NDPEvidenceCollection extends Backbone.Collection
  model: OpinionatersEvidence

  initialize: (models, options) ->
    @on 'change', @sort, @
    @fact = options.fact

    @_wheel = @fact.getFactWheel()
    @_wheel.on 'sync', =>
      @fetch()

  comparator: (item) -> - item.get('impact')

  url: ->
    "/facts/#{@fact.id}/interactors"
