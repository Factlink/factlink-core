#= require ./vote_view

class window.FactRelationVoteDownView extends FactRelationVoteView
  ui:
    fact_relation: '.js-fact-relation-disbelieve'
    fact: '.js-fact-disbelieve'

  template: 'fact_relations/vote_down_popover'

  templateHelpers: =>
    disbelieves_fact_relation: @model.isDisBelieving()
    disbelieves_fact: @model.getFact().getFactWheel().isUserOpinion 'disbelieve'

  save: ->
    @set_fact_relation_opinion 'disbelieves', @ui.fact_relation.is(':checked')
    @set_fact_opinion 'disbelieve', @ui.fact.is(':checked')

    @trigger 'saved'
