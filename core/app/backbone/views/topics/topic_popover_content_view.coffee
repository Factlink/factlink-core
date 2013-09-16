class window.TopicPopoverContentView extends StatisticsPopoverContentView

  onRender: ->
    @buttonRegion.show new FavouriteTopicButtonView topic: @model, mini: true
    @statisticsRegion.show new TopicStatisticsView model: @model
