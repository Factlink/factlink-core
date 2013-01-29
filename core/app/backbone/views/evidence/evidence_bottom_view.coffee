class window.EvidenceBottomView extends Backbone.Marionette.Layout
  className: 'evidence-bottom bottom-base'

  template: 'facts/bottom_base'

  triggers:
    'click .js-sub-comments-link': 'toggleSubCommentsList'

  templateHelpers: ->
    showTime: false
    showRepost: false
    showShare: false
    showSubComments: true
    showFactInfo: ->
      @fact_base.scroll_to_link?
    fact_url_host: ->
      new Backbone.Factlink.Url(@fact_url).host() if @fact_url?
    
  onRender: ->
    @bindTo @model, 'change:sub_comments_count', @updateSubCommentsLink, @
    @updateSubCommentsLink()

  updateSubCommentsLink: ->
    count = @model.get('sub_comments_count')

    count_str = ""

    if count
      count_str = " (#{count})"

    @$(".js-sub-comments-link").text "Comments#{count_str}"
