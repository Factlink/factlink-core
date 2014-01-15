class CommentBottomView extends Backbone.Marionette.Layout
  className: 'discussion-evidenceish-bottom'
  template: 'evidence/comment_bottom'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  ui:
    subCommentsLink:          '.js-sub-comments-link'
    subCommentsLinkContainer: '.js-sub-comments-link-container'

  regions:
    deleteRegion: '.js-delete-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  initialize: ->
    @listenTo @model, 'change', @render

  onRender: ->
    @updateSubCommentsLink()

    if @model.can_destroy()
      @_deleteButtonView = new DeleteButtonView model: @model
      @listenTo @_deleteButtonView, 'delete', -> @model.destroy wait: true
      @deleteRegion.show @_deleteButtonView

  updateSubCommentsLink: ->
    count = @model.get('sub_comments_count')
    countText = switch count
      when 0 then "Comment"
      when 1 then "1 comment"
      else "#{count} comments"
    @ui.subCommentsLink.text countText

    if Factlink.Global.signed_in or count > 0
      @showSubCommentsLink()
    else
      @hideSubCommentsLink()

  showSubCommentsLink: -> @ui.subCommentsLinkContainer.show()
  hideSubCommentsLink: -> @ui.subCommentsLinkContainer.hide()


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

    bottomView = new CommentBottomView model: @model
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
