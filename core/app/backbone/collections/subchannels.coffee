class window.Subchannels extends Backbone.Collection
  model: Subchannel

  initialize: (models, opts) ->
    @channel = opts.channel

  url: -> @channel.url() + '/subchannels'
