class window.FactRelationOrCommentBottomView extends Backbone.Marionette.Layout
  className: 'discussion-evidenceish-bottom'
  template: 'facts/fact_relation_or_comment_bottom'

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
