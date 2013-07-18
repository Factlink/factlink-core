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

  getInteractorsEvidence: ->
    @_interactors ?= switch @type()
      when 'supporting' then @_interactorsPage('believe')
      when 'weakening' then @_interactorsPage('disbelieve')
      when 'doubting' then @_interactorsPage('doubt')
