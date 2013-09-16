class window.StatisticsPopoverContentView extends Backbone.Marionette.Layout
  className: 'statistics-popover-content'

  template: 'popovers/statistics_popover_content'

  regions:
    statisticsRegion: '.js-statistics-region'
    favouriteButtonRegion: '.js-favourite-button-region'

  onRender: ->
    @statisticsRegion.show new TopicStatisticsView(model: @model)
    @favouriteButtonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
