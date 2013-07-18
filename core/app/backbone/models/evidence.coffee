class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence

  # TODO: eventually, fetching this model should populate
  #       the collection, not the other way around
  initialize: (attributes, options) ->
    fact = options.fact ? @collection.fact
    @_wheel = fact.getFactWheel()
    @opinionaters().fetch()

    @_wheel.on 'change', =>
      @_opinionaters?.fetch()


  opinionaters: ->
    return @_opinionaters if @_opinionaters?

    @_opinionaters = new InteractorsPage [],
      fact_id: @_wheel.get('fact_id')
      type: @get('type')
      perPage: 7
    @_opinionaters.on 'reset', =>
      @set impact: @_opinionaters.impact

    @_opinionaters
