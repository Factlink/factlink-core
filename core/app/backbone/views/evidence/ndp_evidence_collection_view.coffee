class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  templateHelpers:
    formatted_impact: -> format_as_authority @impact

  typeCss: ->
    switch @model.get('type')
      when 'believe' then 'evidence-supporting'
      when 'disbelieve' then 'evidence-weakening'
      when 'doubt' then 'evidence-unsure'

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model
    @$el.addClass @typeCss()

class window.NDPEvidenceCollectionView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/ndp_evidence_collection'
  itemView: NDPEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  initialize: ->
    @bindTo @collection, 'change:impact', @render
