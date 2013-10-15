class window.ChannelFacts extends Backbone.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp

  model: Fact

  initialize: (models, opts) -> @channel = opts.channel

  url: ->  @channel.normal_url() + '/facts'

