class window.ChannelFacts extends Backbone.Collection
  model: Fact,

  initialize: (model, opts) -> @channel = opts.channel

  url: -> @channel.url() + '/facts'

_.extend(ChannelFacts.prototype, AutoloadCollectionOnTimestamp)