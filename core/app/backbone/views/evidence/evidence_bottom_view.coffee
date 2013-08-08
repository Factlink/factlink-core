class window.EvidenceBottomView extends Backbone.Marionette.ItemView
  className: 'evidence-bottom bottom-base'

  template: 'facts/evidence_bottom'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  events:
    'click .js-open-proxy-link': 'openEvidenceProxyLink'

  ui:
    subCommentsLink:          '.js-sub-comments-link'
    subCommentsLinkContainer: '.js-sub-comments-link-container'

  initialize: ->
    @listenTo @model, 'change', @render

  templateHelpers: ->
    fact = @model.getFact?()

    showDiscussion: -> @from_fact?
    believe_percentage: fact?.opinionPercentage('believe')
    disbelieve_percentage: fact?.opinionPercentage('disbelieve')
    from_fact_sanitized: fact?.toJSON()

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

  openEvidenceProxyLink: (e) ->
    mp_track "Evidence: Open proxy link",
      site_url: @model.get("from_fact").fact_url

