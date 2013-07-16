class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  className: 'evidence-box'
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  templateHelpers: =>
    type_css: => @typeCss()
    is_unsure: -> @type == 'doubt'
    formatted_impact: -> format_as_authority @impact

  typeCss: ->
    switch @model.get('type')
      when 'believe' then 'supporting'
      when 'disbelieve' then 'weakening'
      when 'doubt' then 'unsure'

  onRender: ->
    @$el.toggle @model.has('impact')
    @contentRegion.show new InteractingUsersView model: @model

class window.NDPEvidenceCollectionView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/ndp_evidence_collection'
  itemView: NDPEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  initialize: ->
    @bindTo @collection, 'change:impact', @render
