window.ReactFeedActivities = React.createBackboneClass
  render: ->
    _div [],
      _header ["content-header"],
        _h1 ["content-title"],
          Factlink.Global.t.stream.capitalize()

      _div [id:"feed_activity_list"],
        ReactActivities
          model: @model()

ReactActivities = React.createBackboneClass
  displayName: 'ReactActivities'

  # this function sets the correct state after loading is done, tries to load more if applicable
  # and sets empty state if we are not loading and we have no items
  checkScrolledPosition: ->
    pixels_under_fold = $(document).height() - ($(window).scrollTop() + $(window).height())

    @model().loadMore() if pixels_under_fold < 700
    console.info 'yo'

  componentDidMount: ->
    @model().loadMore()
    @model().on "remove stopLoading", @checkScrolledPosition, @
    $(window).on "scroll", @checkScrolledPosition

  componentWillUnmount: ->
    $(window).off "scroll", @checkScrolledPosition

  render: ->
    _div [],
      _div ["js-activities-list"],
        @model().map (model) =>
          switch model.get("action")
            when "created_comment", "created_sub_comment"
              ReactCreatedComment(model: model)
            when "followed_user"
              ReactFollowedUser(model: model)
      _div ["empty-stream js-empty-stream"]
