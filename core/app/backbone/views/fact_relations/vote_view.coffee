class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .js-done': 'save'
    'click .js-cancel': 'close'

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
