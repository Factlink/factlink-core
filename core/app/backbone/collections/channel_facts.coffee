class window.ChannelFacts extends Backbone.Collection
  model: Fact

  initialize: (models, opts) -> @channel = opts.channel

  url: ->  @channel.normal_url() + '/facts'

  canAddFact: -> @channel.get('editable?')

_.extend(ChannelFacts.prototype, AutoloadCollectionOnTimestamp)
