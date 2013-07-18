class window.NDPEvidenceCollection extends Backbone.Collection
  model: OpinionatersEvidence

  initialize: (models, options) ->
    @on 'change', @sort, @
    @fact = options.fact

  comparator: (item) -> - item.get('impact')

  url: ->
    "/facts/#{@fact.id}/interactors"
