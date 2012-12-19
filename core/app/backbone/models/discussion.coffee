class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_type = opts.type

  relations: -> @_relations ?= @_getFactRelations()
  comments:  -> @_comments ?= @_getComments()
  evidence:  -> @_evidence ?= @_getEvidence()
  fact: -> @_fact
  type: -> @_type

  _getComments: ->
    switch @type()
      when 'supporting'
        new Comments [], type: 'believes', fact: @fact()
      when 'weakening'
        new Comments [],  type: 'disbelieves', fact: @fact()
      else
        `undefined`

  _getFactRelations: ->
    switch @type()
      when 'supporting'
        new SupportingFactRelations([], fact: @fact())
      when 'weakening'
        new WeakeningFactRelations([], fact: @fact())
      else `undefined`

  _getEvidence: ->
    # TODO this could be refactored, since we are returning EvidenceCollection with @type()
    switch @type()
      when 'supporting'
        new EvidenceCollection [],  type: @type(), fact: @fact()
      when 'weakening'
        new EvidenceCollection [],  type: @type(), fact: @fact()
      else `undefined`

  getInteractors: ->
    collectionType = switch @type()
      when 'supporting' then FactBelieversPage
      when 'weakening' then FactDisbelieversPage
      when 'doubting' then FactDoubtersPage
    new collectionType fact: @fact()
