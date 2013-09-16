class window.UserPopoverContentView extends StatisticsPopoverContentView

  templateHelpers: ->
    title: @model.get('username')

  onRender: ->
    @_showFollowButton()
    @statisticsRegion.show new UserStatisticsView model: @model

  _showFollowButton: ->
    return if @model.is_current_user()

    @buttonRegion.show new FollowUserButtonView user: @model, mini: true
