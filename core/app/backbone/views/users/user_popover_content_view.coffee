class window.UserPopoverContentView extends StatisticsPopoverContentView

  templateHelpers: ->
    heading: @model.get('username')

  onRender: ->
    @statisticsRegion.show new UserStatisticsView model: @model
    @ui.buttonRegion.addClass 'statistics-popover-content-button-hidden'

    @_showFollowButton()

  _showFollowButton: ->
    return if @model.is_current_user()

    @buttonRegion.show new FollowUserButtonView user: @model, mini: true
    @ui.buttonRegion.removeClass 'statistics-popover-content-button-hidden'
