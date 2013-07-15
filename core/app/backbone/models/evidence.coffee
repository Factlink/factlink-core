class window.Evidence extends Backbone.Model

class window.OpinionatersEvidence extends Evidence
  initialize: (opts) ->
    @set type: opts.type
    @set fact_id: opts.fact_id

  opinionaters: ->
    @_opinionaters ?= new NDPInteractorsPage
      fact_id: @get('fact_id')
      type: @get('type')
