class window.GenericEvidenceBottomView extends Backbone.Marionette.Layout
  template: 'facts/evidence_bottom'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  ui:
    subCommentsLink:          '.js-sub-comments-link'
    subCommentsLinkContainer: '.js-sub-comments-link-container'

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


# NOTE : when removing this class, don't forget to cleanup the template.
class window.EvidenceBottomView extends GenericEvidenceBottomView
  className: 'evidence-bottom bottom-base pre-ndp-bottom-base'

  templateHelpers: =>
    fact = @model.getFact?()

    showDiscussion: fact?
    believe_percentage:    fact?.opinionPercentage('believe')
    disbelieve_percentage: fact?.opinionPercentage('disbelieve')
    from_fact_sanitized:   fact?.toJSON()

  initialize: ->
    @listenTo @model, 'change', @render

  onRender: ->
    @listenTo @model, 'change:sub_comments_count', @updateSubCommentsLink
    @updateSubCommentsLink()


class window.NDPFactRelationOrCommentBottomView extends EvidenceBottomView
  className: 'ndp-evidenceish-bottom bottom-base'

  regions:
    deleteRegion: '.js-delete-region'

  templateHelpers: =>
    showTimeAgo: true
    showDelete: @model.can_destroy()

  onRender: ->
    @listenTo @model, 'change:sub_comments_count', @updateSubCommentsLink
    @updateSubCommentsLink()

    if @model.can_destroy()
      @_deleteButtonView = new DeleteButtonView model: @model
      @listenTo @_deleteButtonView, 'delete', -> @model.destroy wait: true
      @deleteRegion.show @_deleteButtonView
