class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_type = opts.type

  evidence:  -> @_evidence ?= @_getEvidence()

  fact: -> @_fact
  type: -> @_type

  _getEvidence: ->
    new OneSidedEvidenceCollection [], type: @type(), fact: @fact()

  _interactorsPage: (type)->
    new OpinionatersEvidence({type: type}, fact: @_fact)

  getInteractors: ->
    switch @type()
      when 'supporting' then @_interactorsPage('believes')
      when 'weakening' then @_interactorsPage('disbelieves')
      when 'doubting' then @_interactorsPage('doubts')
