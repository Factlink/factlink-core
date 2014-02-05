window.ReactComments = React.createBackboneClass
  displayName: 'ReactComments'

  render: ->
    R.div {},
      @model().map (comment) =>
        ReactComment(model: comment, key: comment.get('id'))


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

    @collectionRegion.show new ReactView
      component: ReactComments
        model: @collection

    @_updateLoading()

  _updateLoading: ->
    @ui.loading.toggle @collection.loading()
