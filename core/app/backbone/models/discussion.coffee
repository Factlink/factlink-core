class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_type = opts.type

  evidence:  -> @_evidence ?= @_getEvidence()

  fact: -> @_fact
  type: -> @_type

  _getEvidence: ->
    new OneSidedEvidenceCollection [], type: @type(), fact: @fact()

  interactorsPage: (type)->
    new InteractorsPage [],
      type: type
      fact_id: @fact().id
      perPage: 3

  getInteractors: ->
    switch @type()
      when 'supporting' then @interactorsPage('believe')
      when 'weakening' then @interactorsPage('disbelieve')
      when 'doubting' then @interactorsPage('doubt')
