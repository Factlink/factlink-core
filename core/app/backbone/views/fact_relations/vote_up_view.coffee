#= require ./vote_view

class window.FactRelationVoteUpView extends FactRelationVoteView
  ui:
    fact_relation: '.js-fact-relation-believe'
    fact: '.js-fact-believe'

  template: 'fact_relations/vote_up_popover'

  templateHelpers: =>
    believes_fact_relation = @model.isBelieving()
    believes_fact = @model.getFact().getFactWheel().isUserOpinion 'believe'

    has_some_opinion = @model.current_opinion() or @model.getFact().getFactWheel().userOpinion()

    if has_some_opinion
      believes_fact_relation: believes_fact_relation
      believes_fact: believes_fact
    else
      believes_fact_relation: true
      believes_fact: true

  save: ->
    if @ui.fact_relation.is(':checked')
      @set_fact_relation_opinion 'believes'
    else
      @unset_fact_relation_opinion 'believes'

    if @ui.fact.is(':checked')
      @set_fact_opinion 'believe'
    else
      @unset_fact_opinion 'believe'

    @trigger 'saved'
