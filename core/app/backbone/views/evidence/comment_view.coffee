class CommentReplyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template:
    text: "({{sub_comments_count}}) Reply"

  initialize: ->
    @listenTo @model, 'change:sub_comments_count', @render


class window.CommentView extends Backbone.Marionette.Layout
  className: 'evidence-argument'
  template: 'evidence/comment'

  events:
    'click .js-sub-comments-link': 'toggleSubCommentsView'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  regions:
    voteRegion: '.js-vote-region'
    headingRegion: '.js-heading-region'
    subCommentsRegion: '.js-sub-comments-region'
    deleteRegion: '.js-delete-region'
    subCommentsLinkRegion: '.js-sub-comments-link-region'

  initialize: ->
    @listenTo @model, 'change:formatted_comment_content', @render

  onRender: ->
    @$el.addClass @_typeCss()
    @listenTo @model.argumentTally(), 'change', @_updateIrrelevance
    @_updateIrrelevance()
    @voteRegion.show new EvidenceVoteView model: @model.argumentTally()
    @headingRegion.show new EvidenceishHeadingView model: @model.creator()

    if @model.can_destroy()
      @_deleteButtonView = new DeleteButtonView model: @model
      @listenTo @_deleteButtonView, 'delete', -> @model.destroy wait: true
      @deleteRegion.show @_deleteButtonView

    @subCommentsLinkRegion.show new CommentReplyView model: @model

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
