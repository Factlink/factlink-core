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
      @model.getFact().getFactWheel().setActiveOpinionType opinion

  unset_fact_opinion: (opinion) ->
    is_current_opinion = @model.getFact().getFactWheel().isUserOpinion opinion
    if is_current_opinion
      if @_originalFactOpinion?
        @model.getFact().getFactWheel().setActiveOpinionType @_originalFactOpinion
        @_originalFactOpinion = null
      else
        @model.getFact().getFactWheel().unsetActiveOpinionType opinion
