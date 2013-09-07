#= require ./vote_view

class window.FactRelationVoteUpView extends FactRelationVoteView

  events:
    'click .js-fact-believe': 'factBelieve'
    'click .js-fact-unbelieve': 'factUnbelieve'
    'click .js-fact-relation-believe': 'factRelationBelieve'
    'click .js-fact-relation-unbelieve': 'factRelationUnbelieve'

  ui:
    fact_relation: '.js-fact-relation-believe'
    fact: '.js-fact-believe'

  template: 'fact_relations/vote_up_popover'

  templateHelpers: =>
    believes_fact_relation: @model.isBelieving()
    believes_fact: @model.getFact().getFactWheel().isUserOpinion 'believe'

  factBelieve: -> @set_fact_opinion 'believe'
  factUnbelieve: -> @unset_fact_opinion 'believe'
  factRelationBelieve: -> @set_fact_relation_opinion 'believes'
  factRelationUnbelieve: -> @unset_fact_relation_opinion 'believes'
