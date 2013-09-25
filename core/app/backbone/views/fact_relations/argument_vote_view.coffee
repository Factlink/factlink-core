class VoteLineView extends Backbone.Marionette.ItemView

  className: 'vote-up-down-line'

  events:
    'click .js-believe':    -> @model.believe()
    'click .js-disbelieve': -> @model.disbelieve()
    'click .js-undo':       -> @model.undoOpinion()

  templateHelpers: =>
    believes: @model.isBelieving()
    disbelieves: @model.isDisBelieving()

  onChange: ->
    @render()
    _.defer (=> @$el.addClass 'vote-up-down-highlight')
    _.delay (=> @$el.removeClass 'vote-up-down-highlight'), 1000

class FactVoteLineView extends VoteLineView
  modelEvents:
    'sync': 'onChange'

class FactRelationVoteLineView extends VoteLineView
  modelEvents:
    'change:current_user_opinion': 'onChange'

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
