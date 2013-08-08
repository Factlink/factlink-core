class window.GenericEvidenceBottomView extends Backbone.Marionette.ItemView
  className: 'evidence-bottom bottom-base'

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
    count = @model.get('sub_comments_count')

    if count > 0
      @ui.subCommentsLink.text "Comments (#{count})"
    else
      @ui.subCommentsLink.text "Comments"

    if Factlink.Global.signed_in or count > 0
      @showSubCommentsLink()
    else
      @hideSubCommentsLink()

  showSubCommentsLink: -> @ui.subCommentsLinkContainer.removeClass 'hide'
  hideSubCommentsLink: -> @ui.subCommentsLinkContainer.addClass 'hide'

class window.EvidenceBottomView extends GenericEvidenceBottomView
  templateHelpers: =>
    fact = @model.getFact?()

    showDiscussion: fact?
    believe_percentage:    fact?.opinionPercentage('believe')
    disbelieve_percentage: fact?.opinionPercentage('disbelieve')
    from_fact_sanitized:   fact?.toJSON()

class window.NDPFactRelationOrCommentBottomView extends EvidenceBottomView
  templateHelpers: =>
    showTimeAgo: true
