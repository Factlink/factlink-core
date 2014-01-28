class EvidenceCollectionView extends Backbone.Marionette.CollectionView
  itemView: CommentView

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

  onRender: ->
    if Factlink.Global.signed_in
      @_addEvidenceFormView = new AddEvidenceFormView collection: @collection
      @formRegion.show @_addEvidenceFormView

    else
      @opinionHelpRegion.show new ReactView
        component: ReactOpinionHelp
          collection: @collection

    @collectionRegion.show new EvidenceCollectionView collection: @collection
    @_updateLoading()

  _updateLoading: ->
    @ui.loading.toggle @collection.loading()
