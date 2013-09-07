class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .js-done': 'save'
    'click .js-cancel': 'close'

  set_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    @model.setOpinion opinion unless is_current_opinion

  unset_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    @model.removeOpinion() if is_current_opinion

  set_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    @_set_fact_opinion opinion unless is_current_opinion

  unset_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    @_unset_fact_opinion opinion if is_current_opinion

  _set_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().setActiveOpinionType opinion

  _unset_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().unsetActiveOpinionType opinion
