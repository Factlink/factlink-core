class NDPFactRelationOrCommentAvatarView extends Backbone.Marionette.ItemView
  className: 'ndp-evidence-heading'
  template: 'evidence/ndp_fact_relation_or_comment_avatar'


class NDPCommentView extends Backbone.Marionette.ItemView
  className: 'ndp-evidenceish-text'
  template: 'evidence/ndp_comment'


class window.NDPFactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'ndp-evidenceish'
  template: 'evidence/ndp_fact_relation_or_comment'

  regions:
    contentRegion: '.js-content-region'
    bottomRegion: '.js-bottom-region'
    headingRegion: '.js-heading-region'
    subCommentsRegion: '.js-sub-comments-region'

  onRender: ->
    @headingRegion.show new NDPEvidenceishHeadingView model: @model.creator()

    if @model instanceof Comment
      @contentRegion.show new NDPCommentView model: @model
    else if @model instanceof FactRelation
      @contentRegion.show @_factBaseView()
    else
      throw "Invalid type of model: #{@model}"

    bottomView = new NDPFactRelationOrCommentBottomView model: @model
    @listenTo bottomView, 'toggleSubCommentsList', @toggleSubCommentsView
    @bottomRegion.show bottomView

  toggleSubCommentsView: ->
    if @subCommentsOpen
      @subCommentsOpen = false
      @subCommentsRegion.close()
    else
      @subCommentsOpen = true
      @subCommentsRegion.show new NDPSubCommentsView
        collection: new SubComments([], parentModel: @model)

  _factBaseView: ->
    view = new FactBaseView model: @model.getFact(), clickable_body: Factlink.Global.signed_in

    @listenTo @model.getFact().getFactWheel(), 'sync', ->
      @model.fetch()

    if Factlink.Global.signed_in
      @listenTo view, 'click:body', (e) ->
        @defaultClickHandler e, @model.getFact().get("url")

    view
