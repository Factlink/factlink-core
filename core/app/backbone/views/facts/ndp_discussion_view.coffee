class window.NDPDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'ndp_discussion'

  template: 'facts/ndp_discussion'

  regions:
    learnMoreRegion: '.js-region-learn-more'
    factRegion: '.js-region-ndp-fact'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new NDPEvidenceCollection null, fact: @model
    opinionaters_collection.fetch()

    @evidenceRegion.show new NDPEvidenceContainerView
      collection: opinionaters_collection

    unless Factlink.Global.signed_in
      @learnMoreRegion.show new LearnMorePopupView
