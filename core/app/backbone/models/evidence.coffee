class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence
  opinionaters: ->
    return @_opinionaters if @_opinionaters?
    @_opinionaters = new NDPInteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')

    @_opinionaters.on 'reset', =>
      console.info 'yo', @_opinionaters.impact
      @set impact: @_opinionaters.impact

    @_opinionaters
