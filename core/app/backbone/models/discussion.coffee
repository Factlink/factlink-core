class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_type = opts.type

  evidence:  -> @_evidence ?= @_getEvidence()

  fact: -> @_fact
  type: -> @_type

  _getEvidence: ->
    if @type() == 'supporting' or @type == 'weakening'
      new EvidenceCollection [], type: @type(), fact: @fact()

  getInteractors: ->
    collectionType = switch @type()
      when 'supporting' then FactBelieversPage
      when 'weakening' then FactDisbelieversPage
      when 'doubting' then FactDoubtersPage
    new collectionType fact: @fact()
