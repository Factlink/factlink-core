class FactRelationVoteView extends Backbone.Marionette.ItemView

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

  ui:
    factRelationLine: '.js-fact-relation-line'
    factLine: '.js-fact-line'


  templateHelpers: =>
    believes_fact_relation: @model.isBelieving()
    believes_fact: @model.getFact().getFactWheel().isUserOpinion 'believe'
    disbelieves_fact_relation: @model.isDisBelieving()
    disbelieves_fact: @model.getFact().getFactWheel().isUserOpinion 'disbelieve'

  constructor: ->
    super
    @listenTo @model, "change:current_user_opinion", ->
      @render()
      @highlight @ui.factRelationLine
    @listenTo @model.getFact().getFactWheel(), "sync", ->
      @render()
      @highlight @ui.factLine

  highlight: ($el) ->
    _.defer (-> $el.addClass 'vote-up-down-highlight')
    _.delay (-> $el.removeClass 'vote-up-down-highlight'), 700

  set_fact_relation_opinion: (opinion) ->
    return if @model.current_opinion() == opinion

    @model.setOpinion opinion

  unset_fact_relation_opinion: (opinion) ->
    return unless @model.current_opinion() == opinion

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

class window.FactRelationVoteUpView extends FactRelationVoteView
  template: 'fact_relations/vote_up_popover'

class window.FactRelationVoteDownView extends FactRelationVoteView
  template: 'fact_relations/vote_down_popover'
