class window.TopicPopoverContentView extends Backbone.Marionette.Layout
  className: 'topic-popover-content'

  template: 'topics/popover_content'

  regions:
    topicStatisticsRegion: '.js-topic-statistics-region'
    favouriteButtonRegion: '.js-favourite-button-region'

  onRender: ->
    @topicStatisticsRegion.show new TopicStatisticsView(model: @model)
    @favouriteButtonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
