#= require ./fact_relation_or_comment_view

class EvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: FactRelationOrCommentView

  # Add new evidence at the top of the list
  appendHtml: (collectionView, itemView, index) ->
    return super if collectionView.isBuffering

    collectionView.$el.prepend itemView.el

class window.EvidenceContainerView extends Backbone.Marionette.Layout
  className: 'evidence-container'
  template: 'evidence/evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    opinionHelpRegion: '.js-opinion-help-region'
    formRegion: '.js-form-region'

  collectionEvents:
    'request sync': '_updateLoading'

  ui:
    loading: '.js-evidence-loading'
    opinionHelpRegion: '.js-opinion-help-region'
    formRegion: '.js-form-region'

  initialize: ->
    @_factVotes = @collection.fact.getFactTally()
    @listenTo @_factVotes, 'change:current_user_opinion', @_updateForm

  onRender: ->
    @opinionHelpRegion.show new OpinionHelpView collection: @collection
    @formRegion.show new AddEvidenceFormView collection: @collection
    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()
    @_updateForm()

  _updateLoading: ->
    @ui.loading.toggle @collection.loading()

  _updateForm: ->
    showForm = @_factVotes.get('current_user_opinion') != 'no_vote'

    @ui.opinionHelpRegion.toggle !showForm
    @ui.formRegion.toggle showForm
