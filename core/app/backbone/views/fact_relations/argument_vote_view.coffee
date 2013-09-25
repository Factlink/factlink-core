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

class FactVoteUpLineView extends VoteLineView
  template: 'facts/vote_up_line'
  modelEvents: {'sync': 'onChange'}

class FactVoteDownLineView extends VoteLineView
  template: 'facts/vote_down_line'
  modelEvents: {'sync': 'onChange'}

class FactRelationVoteUpLineView extends VoteLineView
  template: 'fact_relations/vote_up_line'
  modelEvents: {'change:current_user_opinion': 'onChange'}

class FactRelationVoteDownLineView extends VoteLineView
  template: 'fact_relations/vote_down_line'
  modelEvents: {'change:current_user_opinion': 'onChange'}


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
    @factRelationLineRegion.show new FactRelationVoteUpLineView model: @model
    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteUpLineView @model.getFact().getFactWheel()

class window.ArgumentVoteDownView extends ArgumentVoteView
  onRender: ->
    @factRelationLineRegion.show new FactRelationVoteDownLineView model: @model

    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteDownLineView model: @model.getFact().getFactWheel()
