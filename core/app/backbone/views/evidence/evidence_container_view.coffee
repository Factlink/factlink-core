class EvidenceView extends Backbone.Marionette.Layout
  className: 'evidence-argument'
  template: 'evidence/evidence_layout'

  regions:
    contentRegion: '.js-content-region'
    voteRegion: '.js-vote-region'

  typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  onRender: ->
    @$el.addClass @typeCss()
    @contentRegion.show new FactRelationOrCommentView model: @model
    @listenTo @model.argumentVotes(), 'change', @_updateIrrelevance
    @_updateIrrelevance()
    @voteRegion.show new EvidenceVoteView model: @model.argumentVotes()

  _updateIrrelevance: ->
    relevant = @model.argumentVotes().relevance() >= 0
    @$el.toggleClass 'evidence-irrelevant', !relevant

class EvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: EvidenceView
  className: 'evidence-listing'

class window.EvidenceContainerView extends Backbone.Marionette.Layout
  className: 'evidence-container'
  template: 'evidence/evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    addArgumentRegion: '.js-add-argument-region'
    learnMoreRegion: '.js-learn-more-region'

  collectionEvents:
    'request sync': '_updateLoading'

  ui:
    loading: '.js-evidence-loading'
    loaded: '.js-evidence-loaded'

  onRender: ->
    unless Factlink.Global.signed_in
      @learnMoreRegion.show new LearnMoreView

    @addArgumentRegion.show new AddOpinionOrEvidenceView
      collection: @collection

    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()

  _updateLoading: ->
    @ui.loading.toggle !!@collection.loading()
    @ui.loaded.toggle !@collection.loading()
