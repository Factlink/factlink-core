class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_relations = opts.relations
    @_type = opts.type

  relations: -> @_relations
  fact: -> @_fact
  type: -> @_type
