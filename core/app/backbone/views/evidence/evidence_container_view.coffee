window.ReactComments = React.createBackboneClass
  displayName: 'ReactComments'
  changeOptions: 'add remove reset sort sync request'

  componentWillMount: ->
    @model().fetchIfUnloaded()

  render: ->
    _div [],
      ReactLoadingIndicator() if @model().loading()
      @model().map (comment) =>
        ReactComment
          model: comment
          key: comment.get('id')
          fact_opinionators: @model().fact.getOpinionators()


class window.EvidenceContainerView extends Backbone.Marionette.Layout
  className: 'evidence-container'
  template: 'evidence/evidence_container'

  regions:
    collectionRegion: '.js-collection-region'
    opinionHelpRegion: '.js-opinion-help-region'
    formRegion: '.js-form-region'

  ui:
    loading: '.js-evidence-loading'
    opinionHelpRegion: '.js-opinion-help-region'
    formRegion: '.js-form-region'

  onRender: ->
    if Factlink.Global.signed_in
      @formRegion.show new ReactView
        component: new ReactAddComment
          model: @collection
    else
      @opinionHelpRegion.show new ReactView
        component: ReactOpinionHelp

    @collectionRegion.show new ReactView
      component: ReactComments
        model: @collection
