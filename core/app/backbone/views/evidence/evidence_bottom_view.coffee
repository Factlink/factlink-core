class window.GenericEvidenceBottomView extends Backbone.Marionette.ItemView
  template: 'facts/evidence_bottom'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  ui:
    subCommentsLink:          '.js-sub-comments-link'
    subCommentsLinkContainer: '.js-sub-comments-link-container'

  initialize: ->
    @listenTo @model, 'change', @render

  onRender: ->
    @listenTo @model, 'change:sub_comments_count', @updateSubCommentsLink
    @updateSubCommentsLink()

  updateSubCommentsLink: ->
    count = @model.get('sub_comments_count') || 0
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
  className: 'evidence-bottom bottom-base old-design-bottom-base'

  templateHelpers: =>
    fact = @model.getFact?()

    showDiscussion: fact?
    believe_percentage:    fact?.opinionPercentage('believe')
    disbelieve_percentage: fact?.opinionPercentage('disbelieve')
    from_fact_sanitized:   fact?.toJSON()

class window.NDPFactRelationOrCommentBottomView extends EvidenceBottomView
  className: 'ndp-evidenceish-bottom bottom-base'

  templateHelpers: =>
    showTimeAgo: true
