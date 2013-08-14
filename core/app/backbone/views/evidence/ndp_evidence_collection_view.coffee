class NDPEvidenceImpactView extends Backbone.Marionette.ItemView
  className: 'evidence-impact-text'
  template: 'evidence/ndp_evidence_impact'

  initialize: ->
    @listenTo @model, 'change:impact', @render


class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
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
    @$el.addClass 'evidence-irrelevant' unless @model.positiveImpact()
    @impactRegion.show new NDPEvidenceImpactView model: @model
    this


class NDPVotableEvidenceLayoutView extends NDPEvidenceLayoutView
  className: 'evidence-votable'

  onRender: ->
    @contentRegion.show new NDPFactRelationOrCommentView model: @model

    if Factlink.Global.signed_in
      @voteRegion.show new NDPEvidenceVoteView model: @model
      @$el.addClass 'evidence-has-arrows'


class NDPOpinionatorsEvidenceLayoutView extends NDPEvidenceLayoutView

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model


class NDPEvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: NDPEvidenceLayoutView

  getItemView: (item) ->
    if item instanceof OpinionatersEvidence
      NDPOpinionatorsEvidenceLayoutView
    else
      NDPVotableEvidenceLayoutView


class window.NDPEvidenceContainerView extends Backbone.Marionette.Layout
  className: 'evidence-container'
  template: 'evidence/ndp_evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    addRegion: '.js-add-region'

  collectionEvents:
    'request sync': '_updateLoading'

  ui:
    terminator: '.js-terminator'

  onRender: ->
    @collectionRegion.show new NDPEvidenceCollectionView collection: @collection
    @_updateLoading()

    if Factlink.Global.signed_in
      @ui.terminator.addClass 'evidence-terminator-before-add-evidence'
      @addRegion.show new NDPAddEvidenceView collection: @collection

  _updateLoading: ->
    @$el.toggleClass 'evidence-container-loaded', !@collection.loading()
