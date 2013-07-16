class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence
  opinionaters: ->
    @_opinionaters ?= new InteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')
