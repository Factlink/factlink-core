class CommentView extends Backbone.Marionette.ItemView
  className: 'discussion-evidenceish-text'
  template: 'evidence/comment'


class window.FactRelationOrCommentView extends Backbone.Marionette.Layout
  className: 'evidence-argument'
  template: 'evidence/fact_relation_or_comment'

  regions:
    voteRegion: '.js-vote-region'
    contentRegion: '.js-content-region'
    bottomRegion: '.js-bottom-region'
    headingRegion: '.js-heading-region'
    subCommentsRegion: '.js-sub-comments-region'

  onRender: ->
    @$el.addClass @_typeCss()
    @listenTo @model.argumentTally(), 'change', @_updateIrrelevance
    @_updateIrrelevance()
    @voteRegion.show new EvidenceVoteView model: @model.argumentTally()
    @headingRegion.show new EvidenceishHeadingView model: @model.creator()

    if @model instanceof Comment
      @contentRegion.show new CommentView model: @model
    else if @model instanceof FactRelation
      @contentRegion.show @_factBaseView()
    else
      throw "Invalid type of model: #{@model}"

    bottomView = new FactRelationOrCommentBottomView model: @model
    @listenTo bottomView, 'toggleSubCommentsList', @toggleSubCommentsView
    @bottomRegion.show bottomView

  toggleSubCommentsView: ->
    if @subCommentsOpen
      @subCommentsOpen = false
      @subCommentsRegion.close()
    else
      @subCommentsOpen = true
      @subCommentsRegion.show new SubCommentsView
        collection: new SubComments([], parentModel: @model)

  _factBaseView: ->
    view = new FactBaseView model: @model.getFact()

    @listenTo @model.getFact().getFactTally(), 'sync', ->
      @model.fetch()

    view

  _typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  _updateIrrelevance: ->
    relevant = @model.argumentTally().relevance() >= 0
    @$el.toggleClass 'evidence-irrelevant', !relevant
