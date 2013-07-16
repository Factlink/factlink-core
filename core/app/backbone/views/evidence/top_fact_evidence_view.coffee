class TopFactEvidenceLayoutView extends Backbone.Marionette.Layout
  className: 'evidence-box'
  template: 'evidence/top_fact_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  templateHelpers:
    type_css: ->
      switch @type
        when 'believe' then 'supporting'
        when 'disbelieve' then 'weakening'
        when 'doubt' then 'unsure'

    is_unsure: -> @type == 'doubt'

    formatted_impact: -> format_as_authority @impact

  onRender: ->
    @$el.toggle @model.has('impact')
    @contentRegion.show new InteractingUsersView model: @model

class window.TopFactEvidenceView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/top_fact_evidence'
  itemView: TopFactEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  initialize: ->
    @bindTo @collection, 'change:impact', @render
