class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  templateHelpers: =>
    believes_fact_relation: @model.isBelieving()
    believes_fact: @model.getFact().getFactWheel().isUserOpinion 'believe'
    disbelieves_fact_relation: @model.isDisBelieving()
    disbelieves_fact: @model.getFact().getFactWheel().isUserOpinion 'disbelieve'

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model.getFact().getFactWheel(), "change", @render

  set_fact_relation_opinion: (opinion) ->
    return if @model.current_opinion() == opinion

    @_originalFactRelationOpinion = @model.current_opinion()
    @model.setOpinion opinion

  unset_fact_relation_opinion: (opinion) ->
    return unless @model.current_opinion() == opinion

    if @_originalFactRelationOpinion?
      @model.setOpinion @_originalFactRelationOpinion
      @_originalFactRelationOpinion = null
    else
      @model.removeOpinion()

  set_fact_opinion: (opinion) ->
    return if @model.getFact().getFactWheel().isUserOpinion opinion

    @_originalFactOpinion = @model.getFact().getFactWheel().userOpinion()
    @model.getFact().getFactWheel().setActiveOpinionType opinion

  unset_fact_opinion: (opinion) ->
    return unless @model.getFact().getFactWheel().isUserOpinion opinion

    if @_originalFactOpinion?
      @model.getFact().getFactWheel().setActiveOpinionType @_originalFactOpinion
      @_originalFactOpinion = null
    else
      @model.getFact().getFactWheel().unsetActiveOpinionType opinion
