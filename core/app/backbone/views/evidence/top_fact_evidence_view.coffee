class TopFactEvidenceLayoutView extends Backbone.Marionette.Layout
  template:
    text: """
        {{#is_unsure}}
          <div class="evidence-unsure-right-spacer"></div>
          <div class="evidence-unsure-left-spacer"></div>
        {{/is_unsure}}
        <div class="evidence-{{opinion_type_css}}-impact">
          <div class="shadow"></div>
        </div>
        <div class="evidence-{{opinion_type_css}}-box">
          <div class="shadow"></div>
          Blah.
        </div>
      """

  templateHelpers:
    opinion_type_css: ->
      switch @opinion_type
        when 'believe' then 'supporting'
        when 'disbelieve' then 'weakening'
        when 'doubt' then 'unsure'

    is_unsure: -> @opinion_type == 'doubt'

class window.TopFactEvidenceView extends Backbone.Marionette.CollectionView
  className: 'top-fact-evidence'
  itemView: TopFactEvidenceLayoutView

  constructor: ->
    @collection = new Backbone.Collection [
      new Backbone.Model(impact: 30, opinion_type: 'believe')
      new Backbone.Model(impact: 20, opinion_type: 'doubt')
      new Backbone.Model(impact: 10, opinion_type: 'disbelieve')
    ]
    super
