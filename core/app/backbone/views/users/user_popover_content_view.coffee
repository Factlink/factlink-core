class window.UserPopoverContentView extends StatisticsPopoverContentView

  templateHelpers: ->
    title: @model.get('username')

  onRender: ->
    @buttonRegion.show new FollowUserButtonView user: @model, mini: true
    @statisticsRegion.show new UserStatisticsView model: @model
