class window.TopicSearchView extends Backbone.Marionette.Layout
  className: "topic-search-result search-result"
  template: "topics/topic_search"

  regions:
    topicStatisticsRegion: '.js-topic-statistics-region'

  onRender: ->
    @topicStatisticsRegion.show new TopicStatisticsView model: @model
