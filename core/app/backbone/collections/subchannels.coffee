class window.SubchannelList extends Backbone.Collection
  model: Subchannel
  
  initialize: (opts) ->
    @channel = opts.channel
  
  url: -> @channel.url() + '/subchannels';