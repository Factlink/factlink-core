class window.NDPFactRelationOrCommentBottomView extends Backbone.Marionette.Layout
  className: 'ndp-evidenceish-bottom'
  template: 'facts/evidence_bottom'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  ui:
    subCommentsLink:          '.js-sub-comments-link'
    subCommentsLinkContainer: '.js-sub-comments-link-container'

  regions:
    deleteRegion: '.js-delete-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  onRender: ->
    @listenTo @model, 'change:sub_comments_count', @updateSubCommentsLink
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

  showSubCommentsLink: -> @ui.subCommentsLinkContainer.removeClass 'hide'
  hideSubCommentsLink: -> @ui.subCommentsLinkContainer.addClass 'hide'
