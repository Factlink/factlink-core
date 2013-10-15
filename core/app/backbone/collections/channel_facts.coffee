class window.ChannelFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, options) -> @channel = options.channel

  url: ->  @channel.normal_url() + '/facts'

  canAddFact: -> @channel.get('editable?')

