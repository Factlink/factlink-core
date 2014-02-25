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
