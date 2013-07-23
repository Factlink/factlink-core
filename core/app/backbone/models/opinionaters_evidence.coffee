class window.OpinionatersEvidence extends Evidence

  # TODO: eventually, fetching this model should populate
  #       the collection, not the other way around
  initialize: (attributes, options) ->
    @_fact_id = options.fact_id ? @collection.fact.id

    @on 'change', =>
      @updateOpinionators()

    @updateOpinionators()

  opinionaters: ->
    @_opinionaters ?= new InteractorsPage null,
      fact_id: @_fact_id
      type: @get('type')
      perPage: 7

  updateOpinionators: ->
    @opinionaters().reset @opinionaters().parse(@attributes)
