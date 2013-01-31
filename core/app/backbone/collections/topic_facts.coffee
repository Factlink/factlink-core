class window.TopicFacts extends Backbone.Collection
  model: Fact

  initialize: (models, opts) -> @topic = opts.topic

  url: ->  @topic.url() + '/facts'

  canAddFact: -> false

_.extend(TopicFacts.prototype, AutoloadCollectionOnTimestamp)
