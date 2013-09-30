class window.TopicPopoverContentView extends StatisticsPopoverContentView

  templateHelpers: ->
    heading: @model.get('title')

  onRender: ->
    @buttonRegion.show new FavouriteTopicButtonView topic: @model, mini: true
    @statisticsRegion.show new TopicStatisticsView model: @model
