stripLinks = (formatted_content) ->
  $content = $("<span>#{formatted_content}</span>")
  $content.find('a').replaceWith ->
    $span = $("<span>#{@innerHTML}</span>")
    $span.addClass @className
    $span

  $content.html()

window.ReactFeedActivitiesAutoLoading = React.createBackboneClass
  displayName: 'ReactFeedActivitiesAutoLoading'

  # this function loads more activities, if we're almost at the bottom of the list
  checkScrolledPosition: ->
    pixels_under_fold = $(document).height() - ($(window).scrollTop() + $(window).height())

    @model().loadMore() if pixels_under_fold < 700

  componentDidMount: ->
    if !@model().length
      @model().loadMore()
    @model().on "remove stopLoading", @checkScrolledPosition, @
    $(window).on "scroll", @checkScrolledPosition

  componentWillUnmount: ->
    # createBackboneClass unbinds model
    $(window).off "scroll", @checkScrolledPosition

  render: ->
    _div [],
      @model().map (model) =>
        ReactActivity model: model, key: model.id


window.ReactFeedActivitiesFixed = React.createBackboneClass
  displayName: 'ReactFeedActivitiesFixed'

  render: ->
    _div [],
      @model().map (model) =>
        ReactActivity
          key: model.id
          model: model
      ReactLoadingIndicator model: @model()


ReactActivity = React.createBackboneClass
  displayName: 'ReactActivity'

  render: ->
    switch @model().get("action")
      when "created_comment"
        ReactCreatedCommentActivity model: @model()
      when "created_sub_comment"
        ReactCreatedSubCommentActivity model: @model()
      when "followed_user"
        ReactFollowedUserActivity model: @model()


ReactCreatedCommentActivity = React.createBackboneClass
  displayName: 'ReactCreatedCommentActivity'
  mixins: [UpdateOnFeaturesChangeMixin]

  render: ->
    user = new User @model().get('user')
    fact = new Fact @model().get('fact')
    comment = new Comment @model().get('comment')
    proxy_url =
      if @canHaz('ruby_proxy')
        fact.get('proxy_open_url').replace('fct.li', 'beta.fct.li')
      else
        fact.get('proxy_open_url')

    ReactGenericActivity {
        model: user
        time: @model().get('created_at')
        href: proxy_url
        target: '_blank'
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
  mixins: [UpdateOnFeaturesChangeMixin]

  render: ->
    user = new User @model().get('user')
    fact = new Fact @model().get('fact')
    comment = new Comment @model().get('comment')
    sub_comment = new Comment @model().get('sub_comment')
    proxy_url =
      if @canHaz('ruby_proxy')
        fact.get('proxy_open_url').replace('fct.li', 'beta.fct.li')
      else
        fact.get('proxy_open_url')

    ReactGenericActivity {
        model: user
        time: @model().get('created_at')
        href: proxy_url
        target: '_blank'
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
      _div ["feed-lowest-comment sub-comment-content",
        dangerouslySetInnerHTML: {__html: stripLinks(sub_comment.get('formatted_content'))}]

ReactFollowedUserActivity = React.createBackboneClass
  displayName: 'ReactFollowedUserActivity'

  render: ->
    user = new User @model().get('user')
    followed_user = new User @model().get('followed_user')

    ReactGenericActivity {
        model: user,
        time: @model().get('created_at')
        href: followed_user.link()
        activity_header_action: [
            _span ["feed-activity-description"],
              Factlink.Global.t.followed
            " "
            _a ["feed-activity-username", href: followed_user.link(), rel:"backbone"],
              _img ["avatar-image feed-activity-followed-avatar", src: followed_user.avatar_url(32), style: {height: '32px', width: '32px'}]
              " "
              followed_user.get('name')
          ]
      }

ReactGenericActivity = React.createBackboneClass
  render: ->
    user = @model()

    _div ["feed-activity", "spec-feed-activity"],
      _div ["feed-activity-user"],
        _a [href: user.link(), rel:"backbone"],
          _img ["feed-activity-user-avatar", alt:" ", src: user.avatar_url(48)]

      _div ["feed-activity-container"],
        _div ["feed-activity-heading"],
          _div ["feed-activity-action"],
            _div ["feed-activity-time"],
              TimeAgo(time: this.props.time)

            _a ["feed-activity-username", href: user.link(), rel:"backbone"],
              user.get('name')
            ' '

            this.props.activity_header_action...

        _a ["feed-activity-content", href: @props.href, rel: 'backbone', target: @props.target],
           this.props.children
