class FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .btn-primary': 'save'

  _set_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().setActiveOpinionType opinion

  _unset_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().unsetActiveOpinionType opinion

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

  set_fact_relation_opinion: (new_opinion) ->
    old_opinion = @model.current_opinion()

    if old_opinion == null || 'disbelieves'
      if new_opinion == 'believes'
        @model.setOpinion new_opinion

    if old_opinion == 'believes'
      if new_opinion == 'none'
        @model.removeOpinion()

  set_fact_opinion: (new_opinion) ->
    old_opinion = @model.getFact().getFactWheel().userOpinion()

    if !old_opinion
      if new_opinion == 'believe'
        @_set_fact_opinion new_opinion

    if old_opinion == 'believes'
      if new_opinion == 'none'
        @_unset_fact_opinion new_opinion

    if old_opinion == 'doubt' || 'disbelieve'
      if new_opinion == 'believe'
        @_set_fact_opinion new_opinion

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

  set_fact_relation_opinion: (new_opinion) ->
    old_opinion = @model.current_opinion()

    if old_opinion == null || 'believes'
      if new_opinion == 'disbelieves'
        @model.setOpinion new_opinion

    if old_opinion == 'disbelieves'
      if new_opinion == 'none'
        @model.removeOpinion()

  set_fact_opinion: (new_opinion) ->
    old_opinion = @model.getFact().getFactWheel().userOpinion()

    if !old_opinion
      if new_opinion == 'disbelieve'
        @_set_fact_opinion new_opinion

    if old_opinion == 'disbelieves'
      if new_opinion == 'none'
        @_unset_fact_opinion new_opinion

    if old_opinion == 'doubt' || 'believe'
      if new_opinion == 'disbelieve'
        @_set_fact_opinion new_opinion
