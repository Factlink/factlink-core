class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence
  defaults:
    impact: ''

  initialize: ->
    @fetchImpact()

  opinionaters: ->
    @_opinionaters ?= new NDPInteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')

  # Hack: the evidence endpoint should just return the impact of OpinionatersEvidence
  fetchImpact: ->
    @opinionaters().fetch
      success: => @set 'impact', @opinionaters().impact
