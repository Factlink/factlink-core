class window.CommentView extends Backbone.Marionette.Layout
  className: 'evidence-argument'
  template: 'evidence/comment'

  regions:
    voteRegion: '.js-vote-region'
    bottomRegion: '.js-bottom-region'
    headingRegion: '.js-heading-region'
    subCommentsRegion: '.js-sub-comments-region'

  initialize: ->
    @listenTo @model, 'change:formatted_comment_content', @render

  onRender: ->
    @$el.addClass @_typeCss()
    @listenTo @model.argumentTally(), 'change', @_updateIrrelevance
    @_updateIrrelevance()
    @voteRegion.show new EvidenceVoteView model: @model.argumentTally()
    @headingRegion.show new EvidenceishHeadingView model: @model.creator()

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

  _typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  _updateIrrelevance: ->
    relevant = @model.argumentTally().relevance() >= 0
    @$el.toggleClass 'evidence-irrelevant', !relevant
