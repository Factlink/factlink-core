class window.NDPDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'ndp_discussion'

  template: 'facts/ndp_discussion'

  regions:
    factRegion: '.js-region-ndp-fact'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new NDPEvidenceCollection [], fact: @model

    @evidenceRegion.show new NDPEvidenceCollectionView
      collection: opinionaters_collection
