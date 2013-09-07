class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model.getFact().getFactWheel(), "change", @render

  set_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    unless is_current_opinion
      @_originalFactRelationOpinion = @model.current_opinion()
      @model.setOpinion opinion

  unset_fact_relation_opinion: (opinion) ->
    is_current_opinion = @model.current_opinion() == opinion
    if is_current_opinion
      if @_originalFactRelationOpinion?
        @model.setOpinion @_originalFactRelationOpinion
        @_originalFactRelationOpinion = null
      else
        @model.removeOpinion()

  set_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion

    unless is_current_opinion
      @_originalFactOpinion = @model.getFact().getFactWheel().userOpinion()
      @_set_fact_opinion opinion

  unset_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    if is_current_opinion
      if @_originalFactOpinion?
        @_set_fact_opinion @_originalFactOpinion
        @_originalFactOpinion = null
      else
        @_unset_fact_opinion opinion

  _set_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().setActiveOpinionType opinion

  _unset_fact_opinion: (opinion) ->
    @model.getFact().getFactWheel().unsetActiveOpinionType opinion
