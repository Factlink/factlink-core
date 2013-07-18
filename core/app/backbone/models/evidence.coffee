class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence

  # TODO: eventually, fetching this model should populate
  #       the collection, not the other way around
  initialize: (attributes, options) ->
    @_fact_id = options.fact_id ? @collection.fact.id

    @on 'change:users', =>
      @opinionaters().reset @get('users')

  opinionaters: ->
    @_opinionaters ?= new InteractorsPage @get('users') ? [],
      fact_id: @_fact_id
      type: @get('type')
      perPage: 7
