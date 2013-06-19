class window.TopicPopoverContentView extends Backbone.Marionette.Layout
  template:
    text: """
      <strong>{{title}}</strong>
      <div class="js-topic-statistics-region"></div>
      <div class="js-favourite-button-region"></div>
    """

  regions:
    topicStatisticsRegion: '.js-topic-statistics-region'
    favouriteButtonRegion: '.js-favourite-button-region'

  onRender: ->
    @topicStatisticsRegion.show new TopicStatisticsView(model: @model)
    @favouriteButtonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
