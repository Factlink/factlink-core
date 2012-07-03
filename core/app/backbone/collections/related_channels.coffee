class window.RelatedChannels extends Backbone.Collection
  model: Channel

  initialize: (channels, options) ->
    @topic_url = options.forChannel.get('topic_url')

  url: -> @topic_url + '/related_user_channels'