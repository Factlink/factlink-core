class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  templates =
    believe: 'evidence/top_fact_supporting_evidence_layout'
    disbelieve: 'evidence/top_fact_weakening_evidence_layout'
    doubt: 'evidence/top_fact_unsure_evidence_layout'

  getTemplate: ->
    @template = templates[@model.get 'type']
    super()

  regions:
    contentRegion: '.js-content-region'

  templateHelpers:
    formatted_impact: -> format_as_authority @impact

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model

class window.NDPEvidenceCollectionView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/top_fact_evidence'
  itemView: NDPEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  initialize: ->
    @bindTo @collection, 'change:impact', @render
