class NDPCommentView extends Backbone.Marionette.ItemView
  template: 'evidence/ndp_comment'

class window.NDPFactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'ndp-fact-relation-or-comment'
  template: 'evidence/ndp_fact_relation_or_comment'

  regions:
    contentRegion: '.js-content-region'

  onRender: ->
    if @model instanceof Comment
      @contentRegion.show new NDPCommentView model: @model
    else if @model instanceof FactRelation
      @contentRegion.show new FactBaseView model: @model.getFact()
    else
      "Invalid type of model: #{@model}"
