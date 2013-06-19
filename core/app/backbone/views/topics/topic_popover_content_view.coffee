class window.TopicPopoverContentView extends Backbone.Marionette.Layout
  className: 'topic-popover-content'

  template:
    text: """
      <div class="js-favourite-button-region topic-popover-content-button"></div>
      <div class="topic-popover-content-title">{{title}}</div>
      <div class="js-topic-statistics-region"></div>
    """

  regions:
    topicStatisticsRegion: '.js-topic-statistics-region'
    favouriteButtonRegion: '.js-favourite-button-region'

  onRender: ->
    @topicStatisticsRegion.show new TopicStatisticsView(model: @model)
    @favouriteButtonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
