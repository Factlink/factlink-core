class TopFactEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/top_fact_evidence_layout'

  templateHelpers:
    opinion_type_css: ->
      switch @opinion_type
        when 'believe' then 'supporting'
        when 'disbelieve' then 'weakening'
        when 'doubt' then 'unsure'

    is_unsure: -> @opinion_type == 'doubt'


class window.TopFactEvidenceView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/top_fact_evidence'
  itemView: TopFactEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  constructor: ->
    @collection = new Backbone.Collection [
      new Backbone.Model(impact: 30, opinion_type: 'believe')
      new Backbone.Model(impact: 20, opinion_type: 'doubt')
      new Backbone.Model(impact: 10, opinion_type: 'disbelieve')
    ]
    super
