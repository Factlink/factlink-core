class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence

  # TODO: eventually, fetching this model should populate
  #       the collection, not the other way around
  initialize: (attributes, options) ->
    @_fact_id = options.fact_id ? @collection.fact.id

  opinionaters: ->
    return @_opinionaters if @_opinionaters?

    @_opinionaters = new InteractorsPage @get('users') ? [],
      fact_id: @_fact_id
      type: @get('type')
      perPage: 7
    @_opinionaters.on 'reset', =>
      @set impact: @_opinionaters.impact
    @on 'change:users', =>
      @_opinionaters.reset @get('users')

    @_opinionaters
