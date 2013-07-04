class FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .btn-primary': 'save'

  set_fact_relation_opinion: (opinion) ->
    if opinion == 'none'
      if @model.get('current_user_opinion')
        @model.removeOpinion()
    else if @model.get('current_user_opinion') != opinion
      @model.setOpinion opinion

  set_fact_opinion: (opinion) ->
    # TODO should be able to unset the opinion from here as well.
    return if opinion == 'none'
    @model.getFact().getFactWheel().setActiveOpinionType opinion

class window.FactRelationVoteUpView extends FactRelationVoteView
  ui:
    fact_relation: '.js-fact-relation-believe'
    fact: '.js-fact-believe'

  template: 'fact_relations/vote_up_popover'

  templateHelpers: =>
    believes_fact_relation: => @believes_fact_relation()
    believes_fact: => @believes_fact()

  save: ->
    opinion = if @ui.fact_relation.is(':checked')
                'believes'
              else
                'none'

    @set_fact_relation_opinion opinion

    believe = if @ui.fact.is(':checked')
                'believe'
              else
                'none'

    @set_fact_opinion believe

    @trigger 'saved'

  believes_fact_relation: -> @model.isBelieving()
  believes_fact: ->
    @model.getFact().get('fact_wheel').opinion_types.believe.is_user_opinion

class window.FactRelationVoteDownView extends FactRelationVoteView
  ui:
    fact_relation: '.js-fact-relation-disbelieve'
    fact: '.js-fact-disbelieve'

  template: 'fact_relations/vote_down_popover'

  templateHelpers: =>
    disbelieves_fact_relation: => @disbelieves_fact_relation()
    disbelieves_fact: => @disbelieves_fact()

  save: ->
    opinion = if @ui.fact_relation.is(':checked')
                'disbelieves'
              else
                'none'

    @set_fact_relation_opinion opinion

    believe = if @ui.fact.is(':checked')
                'disbelieve'
              else
                'none'
    @set_fact_opinion believe

    @trigger 'saved'

  disbelieves_fact_relation: -> @model.isDisBelieving()
  disbelieves_fact: ->
    @model.getFact().get('fact_wheel').opinion_types.disbelieve.is_user_opinion
