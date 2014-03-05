stripLinks = (formatted_content) ->
  $content = $("<span>#{formatted_content}</span>")
  $content.find('a').replaceWith ->
    $span = $("<span>#{@innerHTML}</span>")
    $span.addClass @className
    $span

  $content.html()

window.ReactFeedActivities = React.createBackboneClass
  displayName: 'ReactFeedActivities'

  # this function loads more activities, if we're almost at the bottom of the list
  checkScrolledPosition: ->
    pixels_under_fold = $(document).height() - ($(window).scrollTop() + $(window).height())

    @model().loadMore() if pixels_under_fold < 700

  componentDidMount: ->
    @model().loadMore()
    @model().on "remove stopLoading", @checkScrolledPosition, @
    $(window).on "scroll", @checkScrolledPosition

  componentWillUnmount: ->
    # createBackboneClass unbinds model
    $(window).off "scroll", @checkScrolledPosition

  render: ->
    _div [id:"feed_activity_list"],
      @model().map (model) =>
        switch model.get("action")
          when "created_comment"
            ReactCreatedCommentActivity(model: model)
          when "created_sub_comment"
            ReactCreatedSubCommentActivity(model: model)
          when "followed_user"
            ReactFollowedUserActivity(model: model)

ReactCreatedCommentActivity = React.createBackboneClass
  displayName: 'ReactCreatedCommentActivity'

  render: ->
    user = new User @model().get('user')
    fact = new Fact @model().get('fact')
    comment = new Comment @model().get('comment')

    ReactActivity {
        model: user
        time: @model().get('created_at')
        href: fact.get('proxy_open_url')
        activity_header_action: [
          _span ["feed-activity-description"],
            "commented on"
          ]
      },
      ReactFact model: fact
      _div ["feed-lowest-comment comment-content",
        dangerouslySetInnerHTML: {__html: stripLinks(comment.get('formatted_content'))}]

ReactCreatedSubCommentActivity = React.createBackboneClass
  displayName: 'ReactCreatedSubCommentActivity'

  render: ->
    user = new User @model().get('user')
    fact = new Fact @model().get('fact')
    comment = new Comment @model().get('comment')
    sub_comment = new Comment @model().get('sub_comment')

    ReactActivity {
        model: user
        time: @model().get('created_at')
        href: fact.get('proxy_open_url')
        activity_header_action: [
          _span ["feed-activity-description"],
            "replied to"
          ]
      },
      _div ["feed-comment-box"],
        _img ['feed-comment-box-avatar', src: comment.creator().avatar_url(32)]
        _div ["feed-comment-box-balloon"],
          _div ['feed-activity-username'],
            comment.creator().get('name')
          _div ["comment-content",
            dangerouslySetInnerHTML: {__html: stripLinks(comment.get('formatted_content'))}]
      _div ["feed-lowest-comment subcomment-content",
        dangerouslySetInnerHTML: {__html: stripLinks(sub_comment.get('formatted_content'))}]

ReactFollowedUserActivity = React.createBackboneClass
  displayName: 'ReactFollowedUserActivity'

  render: ->
    user = new User @model().get('user')
    followed_user = new User @model().get('followed_user')

    ReactActivity {
        model: user,
        time: @model().get('created_at')
        href: followed_user.link()
        activity_header_action: [
            _span ["feed-activity-description"],
              Factlink.Global.t.followed
            " "
            _span ["feed-activity-username"],
              _img ["avatar-image feed-activity-followed-avatar", src: followed_user.avatar_url(32), style: {height: '32px', width: '32px'}]
              " "
              followed_user.get('name')
          ]
      }

ReactActivity = React.createBackboneClass
  render: ->
    user = @model()

    _div ["feed-activity"],
      _div ["feed-activity-user"],
        _a [href: user.link(), rel:"backbone"],
          _img ["feed-activity-user-avatar", alt:" ", src: user.avatar_url(48)]

      _a ["feed-activity-container", href: @props.href, rel: 'backbone'],
        _div ["feed-activity-heading"],
          _div ["feed-activity-action"],
            _div ["feed-activity-time"],
              TimeAgo(time: this.props.time)

            _span ["feed-activity-username"],
              user.get('name')
            ' '

            this.props.activity_header_action...

        _div ["feed-activity-content"],
           this.props.children
