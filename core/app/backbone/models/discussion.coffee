class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_relations = opts.relations
    @_type = opts.type

  relations: -> @_relations ?= @getFactRelations()
  fact: -> @_fact
  type: -> @_type

  getFactRelations: ->
    switch @type()
      when 'supporting'
        new SupportingFactRelations([],fact: @fact())
      when 'weakening'
        new WeakeningFactRelations([],fact: @fact())
      else `undefined`

  getInteractors: ->
    collectionType = switch @type()
      when 'supporting' then FactBelieversPage
      when 'weakening' then FactDisbelieversPage
      when 'doubting' then FactDoubtersPage
    new collectionType fact: @fact()
