#= require ./vote_view

class window.FactRelationVoteDownView extends FactRelationVoteView

  events:
    'click .js-fact-disbelieve': -> @set_fact_opinion 'disbelieve'
    'click .js-fact-undisbelieve': -> @unset_fact_opinion 'disbelieve'
    'click .js-fact-relation-disbelieve': -> @set_fact_relation_opinion 'disbelieves'
    'click .js-fact-relation-undisbelieve': -> @unset_fact_relation_opinion 'disbelieves'

  template: 'fact_relations/vote_down_popover'
