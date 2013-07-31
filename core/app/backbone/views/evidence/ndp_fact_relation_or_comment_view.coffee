class NDPFactRelationOrCommentAvatarView extends Backbone.Marionette.ItemView
  className: 'ndp-evidence-heading'
  template: 'evidence/ndp_fact_relation_or_comment_avatar'


class NDPCommentView extends Backbone.Marionette.ItemView
  template: 'evidence/ndp_comment'


class window.NDPFactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'ndp-fact-relation-or-comment'
  template: 'evidence/ndp_fact_relation_or_comment'

  regions:
    contentRegion: '.js-content-region'
    avatarRegion: '.js-avatar-region'

  onRender: ->
    @avatarRegion.show new NDPFactRelationOrCommentAvatarView model: @model.creator()

    if @model instanceof Comment
      @contentRegion.show new NDPCommentView model: @model
    else if @model instanceof FactRelation
      @contentRegion.show new FactBaseView model: @model.getFact()
    else
      "Invalid type of model: #{@model}"
