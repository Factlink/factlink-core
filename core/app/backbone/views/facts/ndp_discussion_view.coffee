class window.NDPDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'ndp_discussion'

  template: 'facts/ndp_discussion'

  regions:
    factRegion: '.fact-region'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new NDPEvidenceCollection [
      new OpinionatersEvidence(type: 'believe',    fact_id: @model.id),
      new OpinionatersEvidence(type: 'disbelieve', fact_id: @model.id),
      new OpinionatersEvidence(type: 'doubt',      fact_id: @model.id)
    ]

    @evidenceRegion.show new NDPEvidenceCollectionView
      collection: opinionaters_collection
