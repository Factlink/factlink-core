class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  initialize: ->
    @_originalFactOpinion = @model.getFact().getFactWheel().userOpinion()
    @_originalFactRelationOpinion = @model.current_opinion()

  set_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    @model.setOpinion opinion unless is_current_opinion

  unset_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    if is_current_opinion
      if @_originalFactRelationOpinion? && @model.current_opinion() != opinion
        @model.setOpinion @_originalFactRelationOpinion
      else
        @model.removeOpinion()

  set_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    @_set_fact_opinion opinion unless is_current_opinion

  unset_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    if is_current_opinion
      if @_originalFactOpinion? && !@model.getFact().getFactWheel().isUserOpinion @_originalFactOpinion
        @_set_fact_opinion @_originalFactOpinion
      else
        @_unset_fact_opinion opinion

  _set_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().setActiveOpinionType opinion

  _unset_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().unsetActiveOpinionType opinion
