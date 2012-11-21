class window.Comments extends Backbone.Collection
  model: Comment

  initialize: (opts) ->
    @type = opts.type
    @fact = opts.fact

  url: -> "/facts/#{@fact.id}/comments.json?opinion=#{@type}"
