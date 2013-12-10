class EvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/evidence_layout'

  regions:
    contentRegion: '.js-content-region'
    voteRegion: '.js-vote-region'

  ui:
    relevance: '.js-relevance'

  typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  render: ->
    super
    @$el.addClass @typeCss()
    this

class VotableEvidenceLayoutView extends EvidenceLayoutView
  className: 'evidence-votable'

  onRender: ->
    @contentRegion.show new FactRelationOrCommentView model: @model
    @listenTo @model.argumentVotes(), 'change', @_updateRelevance
    @_updateRelevance()

    if Factlink.Global.signed_in
      @voteRegion.show new EvidenceVoteView model: @model.argumentVotes()
      @$el.addClass 'evidence-has-arrows'

  _updateRelevance: ->
    @ui.relevance.text format_as_short_number(@model.argumentVotes().relevance())

    relevant = @model.argumentVotes().relevance() >= 0
    @$el.toggleClass 'evidence-irrelevant', !relevant

class OpinionatorsEvidenceLayoutView extends EvidenceLayoutView

  shouldShow: ->
    @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model
    @ui.relevance.text format_as_short_number(@model.get('impact'))

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
    loaded: '.js-evidence-loaded'

  onRender: ->
    if Factlink.Global.signed_in
      @addRegion.show new AddEvidenceFormView
        collection: @collection.realEvidenceCollection
        fact_id: @collection.fact.id
        type: 'believes'
    else
      @learnMoreRegion.show new LearnMoreView

    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()

  _updateLoading: ->
    @ui.loading.toggle !!@collection.loading()
    @ui.loaded.toggle !@collection.loading()
    @ui.terminator.toggleClass 'evidence-terminator-circle', !@collection.loading()
