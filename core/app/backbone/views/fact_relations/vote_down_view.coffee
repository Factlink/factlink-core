#= require ./vote_view

class window.FactRelationVoteDownView extends FactRelationVoteView

  events:
    'click .js-fact-disbelieve': 'factDisbelieve'
    'click .js-fact-undisbelieve': 'factUndisbelieve'
    'click .js-fact-relation-disbelieve': 'factRelationDisbelieve'
    'click .js-fact-relation-undisbelieve': 'factRelationUndisbelieve'

  ui:
    fact_relation: '.js-fact-relation-disbelieve'
    fact: '.js-fact-disbelieve'

  template: 'fact_relations/vote_down_popover'

  templateHelpers: =>
    disbelieves_fact_relation: @model.isDisBelieving()
    disbelieves_fact: @model.getFact().getFactWheel().isUserOpinion 'disbelieve'

  factDisbelieve: -> @set_fact_opinion 'disbelieve'
  factUndisbelieve: -> @unset_fact_opinion 'disbelieve'
  factRelationDisbelieve: -> @set_fact_relation_opinion 'disbelieves'
  factRelationUndisbelieve: -> @unset_fact_relation_opinion 'disbelieves'
