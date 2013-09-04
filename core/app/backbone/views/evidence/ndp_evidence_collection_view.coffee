class EvidenceImpactView extends Backbone.Marionette.ItemView
  className: 'evidence-impact-text'
  template: 'evidence/ndp_evidence_impact'

  initialize: ->
    @listenTo @model, 'change:impact', @render


class EvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'
    voteRegion: '.js-vote-region'
    impactRegion: '.js-impact-region'

  typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-supporting'
      when 'disbelieves' then 'evidence-weakening'
      when 'doubts' then 'evidence-unsure'

  render: ->
    super
    @$el.addClass @typeCss()
    @listenTo @model, 'change:impact', @_updateIrrelevant
    @_updateIrrelevant()
    @impactRegion.show new EvidenceImpactView model: @model
    this

  _updateIrrelevant: ->
    @$el.toggleClass 'evidence-irrelevant', !@model.positiveImpact()

class VotableEvidenceLayoutView extends EvidenceLayoutView
  className: 'evidence-votable'

  onRender: ->
    @contentRegion.show new NDPFactRelationOrCommentView model: @model

    if Factlink.Global.signed_in
      @voteRegion.show new NDPEvidenceVoteView model: @model
      @$el.addClass 'evidence-has-arrows'


class OpinionatorsEvidenceLayoutView extends EvidenceLayoutView

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

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
  template: 'evidence/ndp_evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    addRegion: '.js-add-region'
    learnMoreRegion: '.js-learn-more-region'

  collectionEvents:
    'request sync': '_updateLoading'

  ui:
    terminator: '.js-terminator'

  onRender: ->
    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()

    if Factlink.Global.signed_in
      @ui.terminator.addClass 'evidence-terminator-circle'
      @ui.terminator.addClass 'evidence-terminator-before-add-evidence'
      @addRegion.show new NDPAddEvidenceView
        collection: @collection
        fact_id: @collection.fact.id

  _updateLoading: ->
    @$el.toggleClass 'evidence-container-loaded', !@collection.loading()

    unless Factlink.Global.signed_in || @collection.loading()
      @ui.terminator.addClass 'evidence-terminator-circle'
      @learnMoreRegion.show new LearnMoreBottomView
