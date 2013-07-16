class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence
  # TODO: eventually, fetching this model should populate
  #       the collection, not the other way around

  opinionaters: ->
    return @_opinionaters if @_opinionaters?
    @_opinionaters = new NDPInteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')

    @_opinionaters.on 'reset', =>
      @set impact: @_opinionaters.impact

    @_opinionaters
