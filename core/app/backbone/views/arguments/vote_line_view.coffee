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

class window.FactVoteUpLineView extends VoteLineView
  template: 'facts/vote_up_line'
  modelEvents: {'sync': 'onChange'}

class window.FactVoteDownLineView extends VoteLineView
  template: 'facts/vote_down_line'
  modelEvents: {'sync': 'onChange'}

class window.FactRelationVoteUpLineView extends VoteLineView
  template: 'fact_relations/vote_up_line'
  modelEvents: {'change:current_user_opinion': 'onChange'}

class window.FactRelationVoteDownLineView extends VoteLineView
  template: 'fact_relations/vote_down_line'
  modelEvents: {'change:current_user_opinion': 'onChange'}
