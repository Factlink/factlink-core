class FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .btn-primary': 'save'

  set_fact_relation_opinion: (opinion, enable_opinion) ->
    is_current_opinion = @model.current_opinion() == opinion

    if enable_opinion
      @model.setOpinion opinion unless is_current_opinion
    else
      @model.removeOpinion() if is_current_opinion

  set_fact_opinion: (opinion, enable_opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion

    if enable_opinion
      @_set_fact_opinion opinion unless is_current_opinion
    else
      @_unset_fact_opinion opinion if is_current_opinion

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
    @set_fact_relation_opinion 'believes', @ui.fact_relation.is(':checked')
    @set_fact_opinion 'believe', @ui.fact.is(':checked')

    @trigger 'saved'

  believes_fact_relation: -> @model.isBelieving()
  believes_fact: -> @model.getFact().getFactWheel().isUserOpinion 'believe'

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
  disbelieves_fact: -> @model.getFact().getFactWheel().isUserOpinion 'disbelieve'

  set_fact_relation_opinion: (new_opinion) ->
    # TODO: Refactor - almost same as in FactRelationVoteUpVIew
    old_opinion = @model.current_opinion()

    if old_opinion == null || 'believes'
      if new_opinion == 'disbelieves'
        @model.setOpinion new_opinion

    if old_opinion == 'disbelieves'
      if new_opinion == 'none'
        @model.removeOpinion()

  set_fact_opinion: (new_opinion) ->
    # TODO: Refactor - almost same as in FactRelationVoteUpVIew
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
