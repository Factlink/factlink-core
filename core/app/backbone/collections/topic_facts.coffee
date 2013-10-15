class window.TopicFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, opts) -> @topic = opts.topic

  url: ->  @topic.url() + '/facts'
