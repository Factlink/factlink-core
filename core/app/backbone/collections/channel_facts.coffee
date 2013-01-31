class window.ChannelFacts extends Backbone.Collection
  model: Fact

  initialize: (models, opts) -> @channel = opts.channel

  url: ->  @channel.normal_url() + '/facts'

_.extend(ChannelFacts.prototype, AutoloadCollectionOnTimestamp)
