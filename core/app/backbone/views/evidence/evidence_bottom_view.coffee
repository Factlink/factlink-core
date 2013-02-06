class window.EvidenceBottomView extends Backbone.Marionette.ItemView
  className: 'evidence-bottom bottom-base'

  template: 'facts/bottom_base'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  initialize: ->
    @count = 0
    @bindTo @model, 'change', @render, @

  templateHelpers: ->
    showTime: false
    showRepost: false
    showShare: false
    showSubComments: true
    showDiscussion: ->
      Factlink.Global.signed_in && @fact_base?
    showFactInfo: ->
      @fact_base?.scroll_to_link?
    fact_url_host: ->
      new Backbone.Factlink.Url(@fact_url).host() if @fact_url?

  onRender: ->
    @bindTo @model, 'change:sub_comments_count', @updateSubCommentsLink, @
    @updateSubCommentsLink()

  updateSubCommentsLink: ->
    @count = @model.get('sub_comments_count')

    count_str = ""

    count_str = " (#{@count})" if @count > 0

    if Factlink.Global.signed_in || @count > 0
      @$(".js-sub-comments-link").text "Comments#{count_str}"
    else
      @$(".js-sub-comments-link").hide()
