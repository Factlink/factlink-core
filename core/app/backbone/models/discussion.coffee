class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_relations = opts.relations
    @_type = opts.type

  relations: -> @_relations ?= @getFactRelations()
  comments:  -> @_comments ?= @getComments()
  fact: -> @_fact
  type: -> @_type

  getComments: ->
    switch @type()
      when 'supporting'
        new Comments( collection: [], type: 'believes', fact: @fact() )
      when 'weakening'
        new Comments( collection: [],  type: 'disbelieves', fact: @fact() )
      else
        `undefined`

  getFactRelations: ->
    switch @type()
      when 'supporting'
        new SupportingFactRelations([], fact: @fact())
      when 'weakening'
        new WeakeningFactRelations([], fact: @fact())
      else `undefined`

  getInteractors: ->
    collectionType = switch @type()
      when 'supporting' then FactBelieversPage
      when 'weakening' then FactDisbelieversPage
      when 'doubting' then FactDoubtersPage
    new collectionType fact: @fact()
