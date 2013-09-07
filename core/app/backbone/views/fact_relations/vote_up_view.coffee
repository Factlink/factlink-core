#= require ./vote_view

class window.FactRelationVoteUpView extends FactRelationVoteView

  events:
    'click .js-fact-believe': -> @set_fact_opinion 'believe'
    'click .js-fact-unbelieve': -> @unset_fact_opinion 'believe'
    'click .js-fact-relation-believe': -> @set_fact_relation_opinion 'believes'
    'click .js-fact-relation-unbelieve': -> @unset_fact_relation_opinion 'believes'

  template: 'fact_relations/vote_up_popover'
