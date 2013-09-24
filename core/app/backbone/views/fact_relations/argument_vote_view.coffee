highlight = ($el) ->
  _.defer (-> $el.addClass 'vote-up-down-highlight')
  _.delay (-> $el.removeClass 'vote-up-down-highlight'), 1000

class FactVoteLineView extends Backbone.Marionette.ItemView

  className: 'vote-up-down-line'

  events:
    'click .js-fact-believe':      -> @set_opinion 'believe'
    'click .js-fact-unbelieve':    -> @unset_opinion 'believe'
    'click .js-fact-disbelieve':   -> @set_opinion 'disbelieve'
    'click .js-fact-undisbelieve': -> @unset_opinion 'disbelieve'

  templateHelpers: =>
    believes: @model.getFactWheel().isUserOpinion 'believe'
    disbelieves: @model.getFactWheel().isUserOpinion 'disbelieve'

  initialize: ->
    @listenTo @model.getFactWheel(), "sync", ->
      @render()
      highlight @$el

  set_opinion: (opinion) ->
    return if @model.getFactWheel().isUserOpinion opinion

    @model.getFactWheel().setActiveOpinionType opinion

  unset_opinion: (opinion) ->
    return unless @model.getFactWheel().isUserOpinion opinion

    @model.getFactWheel().undoOpinion()

class window.FactVoteUpLineView extends FactVoteLineView
  template: 'facts/vote_up_line'

class window.FactVoteDownLineView extends FactVoteLineView
  template: 'facts/vote_down_line'

class ArgumentVoteView extends Backbone.Marionette.Layout

  className: 'vote-up-down'

  events:
    'click .js-fact-relation-believe':      -> @set_opinion 'believes'
    'click .js-fact-relation-unbelieve':    -> @unset_opinion 'believes'
    'click .js-fact-relation-disbelieve':   -> @set_opinion 'disbelieves'
    'click .js-fact-relation-undisbelieve': -> @unset_opinion 'disbelieves'

  ui:
    factRelationLine: '.js-fact-relation-line'

  regions:
    factLineRegion: '.js-fact-line-region'

  templateHelpers: =>
    believes: @model.isBelieving()
    disbelieves: @model.isDisBelieving()

  initialize: ->
    @listenTo @model, "change:current_user_opinion", ->
      @render()
      highlight @ui.factRelationLine

  set_opinion: (opinion) ->
    return if @model.current_opinion() == opinion

    @model.setOpinion opinion

  unset_opinion: (opinion) ->
    return unless @model.current_opinion() == opinion

    @model.undoOpinion()

class window.ArgumentVoteUpView extends ArgumentVoteView
  template: 'fact_relations/vote_up_popover'

  onRender: ->
    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteUpLineView(model: @model.getFact())

class window.ArgumentVoteDownView extends ArgumentVoteView
  template: 'fact_relations/vote_down_popover'

  onRender: ->
    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteDownLineView(model: @model.getFact())
