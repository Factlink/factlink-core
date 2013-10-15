class window.Subchannels extends Backbone.Collection
  model: Subchannel

  initialize: (models, options) ->
    @channel = options.channel

  url: -> @channel.url() + '/subchannels'
