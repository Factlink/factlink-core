class window.NDPFactRelationOrCommentBottomView extends Backbone.Marionette.Layout
  template:
    text: """
      {{#time_ago}}
        <span class="factlink-icon-time"></span>
        {{time_ago}} {{ global.t.ago }}
      {{/time_ago}}
    """

class NDPCommentView extends Backbone.Marionette.ItemView
  template: 'evidence/ndp_comment'

class window.NDPFactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'ndp-fact-relation-or-comment'
  template: 'evidence/ndp_fact_relation_or_comment'

  regions:
    contentRegion: '.js-content-region'
    bottomRegion: '.js-bottom-region'

  onRender: ->
    if @model instanceof Comment
      @contentRegion.show new NDPCommentView model: @model
    else if @model instanceof FactRelation
      @contentRegion.show new FactBaseView model: @model.getFact()
    else
      throw "Invalid type of model: #{@model}"

    @bottomRegion.show new NDPFactRelationOrCommentBottomView model: @model
