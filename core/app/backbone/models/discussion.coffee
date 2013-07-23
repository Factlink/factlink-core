class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_type = opts.type

    @_fetchOpinionaters()

    @_wheel = @_fact.getFactWheel()
    @_wheel.on 'sync', =>
      @_fetchOpinionaters()

  evidence:  -> @_evidence ?= @_getEvidence()

  fact: -> @_fact
  type: -> @_type

  _getEvidence: ->
    new OneSidedEvidenceCollection [], type: @type(), fact: @fact()

  _interactorsPage: (type)->
    new OpinionatersEvidence({type: type}, fact_id: @_fact.id)

  getInteractorsEvidence: ->
    @_interactors ?= switch @type()
      when 'supporting' then @_interactorsPage('believes')
      when 'weakening' then @_interactorsPage('disbelieves')
      when 'doubting' then @_interactorsPage('doubts')

  _fetchOpinionaters: ->
    @getInteractorsEvidence().opinionaters().fetch()

