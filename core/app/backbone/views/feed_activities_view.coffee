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
          when "created_comment", "created_sub_comment"
            ReactCreatedComment(model: model)
          when "followed_user"
            ReactFollowedUser(model: model)

ReactCreatedComment = React.createBackboneClass
  displayName: 'ReactCreatedComment'

  render: ->
    user = new User @model().get('user')
    fact = new Fact @model().get("fact")

    _div ["feed-activity"],
      _div ["feed-activity-user"],
        _a [href: user.link(), rel:"backbone"],
          _img ["feed-activity-user-avatar", alt:" ", src: user.avatar_url(48)]

      _div ["feed-activity-container"],
        _div ["feed-activity-heading"],
          _div ["feed-activity-action"],
            _a ["feed-activity-username", href: user.link(), rel:"backbone"]
              user.get('name')
            ' '
            _span ["feed-activity-description"],
              "commented on"
          _div ["feed-activity-time"],
            TimeAgo(time: @model().get('created_at'))
        _div [],
          ReactFact model: fact
        _div ["feed-activity-content"],
          '' #still needs the actual comment here


ReactFollowedUser = React.createBackboneClass
  displayName: 'ReactFollowedUser'

  render: ->
    user = new User @model().get('user')
    followed_user = new User @model().get('followed_user')

    _div ['feed-activity'],
      _div ["feed-activity-user"],
        _a [href: user.link(), rel:"backbone"],
          _img ["feed-activity-user-avatar", src: user.avatar_url(48)]

      _div ["feed-activity-container"],
        _div ["feed-activity-heading"],
          _div ["feed-activity-action"],
            _a ["feed-activity-username", href: user.link(), rel:"backbone"],
                user.name
            _span ["feed-activity-description"],
              Factlink.Global.t.followed
            _a ["feed-activity-username", href: followed_user.link(), rel:"backbone"],
              _img ["feed-activity-user-avatar image-32px", src: followed_user.avatar_url(32)]
              followed_user.get('name')
          _div ["feed-activity-time"],
            TimeAgo(time: @model().get('created_at'))
