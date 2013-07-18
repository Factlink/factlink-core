class window.NDPEvidenceCollection extends Backbone.Collection
  initialize: (models, options) ->
    @on 'change', @sort, @
    @fact = options.fact

    unless models?.length > 0
      @reset [
        new OpinionatersEvidence {type: 'believe'},    collection: this
        new OpinionatersEvidence {type: 'disbelieve'}, collection: this
        new OpinionatersEvidence {type: 'doubt'},      collection: this
      ]

  comparator: (item) -> - item.get('impact')

  url: ->
    '/facts/#{@fact.id}/interactors'
