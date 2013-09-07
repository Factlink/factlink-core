class window.FactRelationVoteView extends Backbone.Marionette.ItemView

  className: 'vote-up-down'

  events:
    'click .js-fact-relation-believe':      -> @set_fact_relation_opinion 'believes'
    'click .js-fact-relation-unbelieve':    -> @unset_fact_relation_opinion 'believes'
    'click .js-fact-believe':               -> @set_fact_opinion 'believe'
    'click .js-fact-unbelieve':             -> @unset_fact_opinion 'believe'
    'click .js-fact-relation-disbelieve':   -> @set_fact_relation_opinion 'disbelieves'
    'click .js-fact-relation-undisbelieve': -> @unset_fact_relation_opinion 'disbelieves'
    'click .js-fact-disbelieve':            -> @set_fact_opinion 'disbelieve'
    'click .js-fact-undisbelieve':          -> @unset_fact_opinion 'disbelieve'


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
