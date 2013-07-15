class TopFactEvidenceLayoutView extends Backbone.Marionette.Layout
  template:
    text: """
        Blah
      """

class window.TopFactEvidenceView extends Backbone.Marionette.CollectionView
  className: -> 'top-fact-arguments'

  itemView: TopFactEvidenceLayoutView

  constructor: ->
    @collection = new Backbone.Collection [
      new Backbone.Model(impact: 30, opinion_type: 'believe')
      new Backbone.Model(impact: 20, opinion_type: 'doubt')
      new Backbone.Model(impact: 10, opinion_type: 'disbelieve')
    ]
    super
