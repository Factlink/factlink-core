class window.Comments extends Backbone.Factlink.Collection
  model: Comment

  initialize: (models, options) ->
    @fact = options.fact

  url: -> "/facts/#{@fact.id}/comments"
