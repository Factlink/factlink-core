class ArgumentVoteView extends Backbone.Marionette.Layout
  className: 'vote-up-down'
  template: 'arguments/vote_popover'

  regions:
    factRelationLineRegion: '.js-fact-relation-line-region'
    factLineRegion: '.js-fact-line-region'

  ui:
    separator: '.js-separator'

  initialize: ->
    @on 'render', ->
      @ui.separator.toggle (@model instanceof FactRelation)

class window.ArgumentVoteUpView extends ArgumentVoteView
  onRender: ->
    @factRelationLineRegion.show new FactRelationVoteUpLineView model: @model
    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteUpLineView model: @model.getFact().getFactWheel()

class window.ArgumentVoteDownView extends ArgumentVoteView
  onRender: ->
    @factRelationLineRegion.show new FactRelationVoteDownLineView model: @model
    if @model instanceof FactRelation
      @factLineRegion.show new FactVoteDownLineView model: @model.getFact().getFactWheel()
