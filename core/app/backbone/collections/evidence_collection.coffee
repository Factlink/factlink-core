class window.EvidenceCollection extends Backbone.Factlink.Collection
  model: Comment

  initialize: (models, options) ->
    @fact = options.fact

  url: -> "/facts/#{@fact.id}/comments"
