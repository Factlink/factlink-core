class EvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: ReactView

  # Add new evidence at the top of the list
  appendHtml: (collectionView, itemView, index) ->
    return super if collectionView.isBuffering

    collectionView.$el.prepend itemView.el
  itemViewOptions: (model)->
    component: ReactComment
      model: model

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
    @_factVotes = @collection.fact.getVotes()
    @listenTo @_factVotes, 'change reset add remove', @_updateForm

  onRender: ->
    @_addEvidenceFormView = new AddEvidenceFormView collection: @collection
    @formRegion.show @_addEvidenceFormView
    @opinionHelpRegion.show new OpinionHelpView collection: @collection
    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()
    @_updateForm()

  _updateLoading: ->
    @ui.loading.toggle @collection.loading()

  _updateForm: ->
    showForm = @_factVotes.opinion_for_current_user() != 'no_vote'

    @ui.opinionHelpRegion.toggle !showForm
    @ui.formRegion.toggle showForm
    @_addEvidenceFormView.focus()
