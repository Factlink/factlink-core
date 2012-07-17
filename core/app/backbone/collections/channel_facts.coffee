class window.ChannelFacts extends Backbone.Collection
  model: Fact

  initialize: (model, opts) -> @channel = opts.channel

  url: ->  @channel.normal_url() + '/facts'

_.extend(ChannelFacts.prototype, AutoloadCollectionOnTimestamp)