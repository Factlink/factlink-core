class EvidenceRelevanceView extends Backbone.Marionette.ItemView
  className: 'evidence-relevance-text-container'
  template: 'evidence/evidence_relevance'

  initialize: ->
    @listenTo @model, 'change:impact', @render

class EvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/evidence_layout'

  regions:
    contentRegion: '.js-content-region'
    voteRegion: '.js-vote-region'
    relevanceRegion: '.js-relevance-region'

  typeCss: ->
    if Factlink.Global.can_haz.comments_no_opinions
      return 'evidence-weakening'
    switch @model.get('type')
      when 'believes' then 'evidence-supporting'
      when 'disbelieves' then 'evidence-weakening'
      when 'doubts' then 'evidence-unsure'

  render: ->
    super
    @$el.addClass @typeCss()
    @listenTo @model, 'change:impact', @_updateIrrelevant
    @_updateIrrelevant()
    @relevanceRegion.show new EvidenceRelevanceView model: @model
    this

  _updateIrrelevant: ->
    @$el.toggleClass 'evidence-irrelevant', !@model.positiveImpact()


class VotableEvidenceLayoutView extends EvidenceLayoutView
  className: 'evidence-votable'

  onRender: ->
    @contentRegion.show new FactRelationOrCommentView model: @model

    if Factlink.Global.signed_in
      @voteRegion.show new EvidenceVoteView model: @model
      @$el.addClass 'evidence-has-arrows'


class OpinionatorsEvidenceLayoutView extends EvidenceLayoutView

  shouldShow: ->
    return false if Factlink.Global.can_haz.comments_no_opinions
    @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model


class EvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: EvidenceLayoutView
  className: 'evidence-listing'

  getItemView: (item) ->
    if item instanceof OpinionatersEvidence
      OpinionatorsEvidenceLayoutView
    else
      VotableEvidenceLayoutView


class window.EvidenceContainerView extends Backbone.Marionette.Layout
  className: 'evidence-container'
  template: 'evidence/evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    addRegion: '.js-add-region'
    learnMoreRegion: '.js-learn-more-region'

  collectionEvents:
    'request sync': '_updateLoading'

  ui:
    terminator: '.js-terminator'
    loading: '.js-evidence-loading'

  onRender: ->
    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()

    if Factlink.Global.signed_in
      @ui.terminator.addClass 'evidence-terminator-before-add-evidence'
      @addRegion.show new AddEvidenceView
        collection: @collection
        fact_id: @collection.fact.id

  _updateLoading: ->
    @ui.loading.toggle !!@collection.loading()
    @ui.terminator.toggleClass 'evidence-terminator-circle', !@collection.loading()

    unless Factlink.Global.signed_in || @collection.loading()
      @learnMoreRegion.show new LearnMoreBottomView
