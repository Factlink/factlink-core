highlight = ($el) ->
  _.defer (-> $el.addClass 'vote-up-down-highlight')
  _.delay (-> $el.removeClass 'vote-up-down-highlight'), 1000

class FactVoteLineView extends Backbone.Marionette.ItemView

  className: 'vote-up-down-line'

  events:
    'click .js-believe':      -> @model.believe()
    'click .js-unbelieve':    -> @unset_opinion 'believe'
    'click .js-disbelieve':   -> @model.disbelieve()
    'click .js-undisbelieve': -> @unset_opinion 'disbelieve'

  templateHelpers: =>
    believes: @model.isUserOpinion 'believe'
    disbelieves: @model.isUserOpinion 'disbelieve'

  initialize: ->
    @listenTo @model, "sync", ->
      @render()
      highlight @$el

  unset_opinion: (opinion) ->
    return unless @model.isUserOpinion opinion

    @model.undoOpinion()

class FactRelationVoteLineView extends Backbone.Marionette.ItemView

  className: 'vote-up-down-line'

  events:
    'click .js-believe':      -> @model.believe()
    'click .js-unbelieve':    -> @unset_opinion 'believes'
    'click .js-disbelieve':   -> @model.disbelieve()
    'click .js-undisbelieve': -> @unset_opinion 'disbelieves'

  templateHelpers: =>
    believes: @model.isBelieving()
    disbelieves: @model.isDisBelieving()

  initialize: ->
    @listenTo @model, "change:current_user_opinion", ->
      @render()
      highlight @$el

  unset_opinion: (opinion) ->
    return unless @model.current_opinion() == opinion

    @model.undoOpinion()

class ArgumentVoteView extends Backbone.Marionette.Layout
  className: 'vote-up-down'
  template: 'arguments/vote_popover'

  regions:
    factRelationLineRegion: '.js-fact-relation-line-region'
    factLineRegion: '.js-fact-line-region'

  initialize: ->
    if @model instanceof FactRelation
      @$el.addClass 'vote-up-down-with-fact'

class window.ArgumentVoteUpView extends ArgumentVoteView
  onRender: ->
    @factRelationLineRegion.show new FactRelationVoteLineView
      template: 'fact_relations/vote_up_line'
      model: @model

    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteLineView
        template: 'facts/vote_up_line'
        model: @model.getFact().getFactWheel()

class window.ArgumentVoteDownView extends ArgumentVoteView
  onRender: ->
    @factRelationLineRegion.show new FactRelationVoteLineView
      template: 'fact_relations/vote_down_line'
      model: @model

    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteLineView
        template: 'facts/vote_down_line'
        model: @model.getFact().getFactWheel()
