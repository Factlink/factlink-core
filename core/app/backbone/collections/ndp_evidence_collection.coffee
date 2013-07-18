class window.NDPEvidenceCollection extends Backbone.Collection
  initialize: (models, options) ->
    @on 'change', @sort, @
    @fact = options.fact

  constructor: (models, options) ->
    super
    unless models and models.length > 0
      @reset [
        new OpinionatersEvidence({type: 'believe'   }, fact: @fact),
        new OpinionatersEvidence({type: 'disbelieve'}, fact: @fact),
        new OpinionatersEvidence({type: 'doubt'     }, fact: @fact)
      ]

  comparator: (item) -> - item.get('impact')

  url: ->
    '/facts/#{@fact.id}/interactors'
