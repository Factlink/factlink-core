class window.NDPDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'ndp_discussion'

  template: 'facts/ndp_discussion'

  regions:
    factRegion: '.js-region-ndp-fact'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new NDPEvidenceCollection [
      new OpinionatersEvidence({type: 'believes'   }, fact: @model),
      new OpinionatersEvidence({type: 'disbelieves'}, fact: @model),
      new OpinionatersEvidence({type: 'doubts'     }, fact: @model)
    ]

    @evidenceRegion.show new NDPEvidenceCollectionView
      collection: opinionaters_collection
