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


class NDPAddEvidenceView extends Backbone.Marionette.ItemView
  className: 'evidence-add'

  template:
    text: """
      <div class="js-buttons">
        <div class="evidence-add-circle"></div>
        <div class="evidence-add-weakening-line"></div>
        <div class="evidence-add-supporting-line"></div>
        <div class="evidence-add-weakening js-weakening-button"></div>
        <div class="evidence-add-supporting js-supporting-button"></div>
      </div>

      <div class="js-box">
        <div class="evidence-impact">Hoi</div>
        <div class="evidence-box ndp-evidenceish ndp-evidenceish-box">
          <div class="evidence-box-triangle"></div>
          Mai
        </div>
      </div>
    """

  ui:
    buttons: '.js-buttons'
    box: '.js-box'

  events:
    'click .js-supporting-button': 'showAddSupporting'
    'click .js-weakening-button': 'showAddWeakening'

  onRender: ->
    @ui.box.hide()

  showAddSupporting: -> @_showAdd true
  showAddWeakening:  -> @_showAdd false

  _showAdd: (supporting) ->
    @ui.buttons.hide()
    @ui.box.show()
    @ui.box.toggleClass 'evidence-weakening', !supporting
    @ui.box.toggleClass 'evidence-supporting', !!supporting

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

  onRender: ->
    @collectionRegion.show new NDPEvidenceCollectionView collection: @collection
    @_updateLoading()

    if Factlink.Global.signed_in
      @$el.addClass 'evidence-container-has-add'
      @addRegion.show new NDPAddEvidenceView collection: @collection

  _updateLoading: ->
    @$el.toggleClass 'evidence-container-is-loading', @collection.loading()
