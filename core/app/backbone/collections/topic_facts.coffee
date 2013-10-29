class window.TopicFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, options) -> @topic = options.topic

  url: ->  @topic.url() + '/facts'
