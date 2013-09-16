class window.StatisticsPopoverContentView extends Backbone.Marionette.Layout
  className: 'statistics-popover-content'

  template: 'popovers/statistics_popover_content'

  regions:
    statisticsRegion: '.js-statistics-region'
    buttonRegion: '.js-button-region'

  onRender: ->
    @buttonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
    @statisticsRegion.show new TopicStatisticsView(model: @model)
