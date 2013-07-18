class window.NDPEvidenceCollection extends Backbone.Collection
  initialize: (models, options) ->
    @on 'change', @sort, @
    @fact = options.fact

    unless models?.length > 0
      @reset [
        new OpinionatersEvidence {type: 'believes'},    collection: this
        new OpinionatersEvidence {type: 'disbelieves'}, collection: this
        new OpinionatersEvidence {type: 'doubts'},      collection: this
      ]

  comparator: (item) -> - item.get('impact')
