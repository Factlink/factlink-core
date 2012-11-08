class window.RelatedChannels extends Backbone.Collection
  model: Channel

  initialize: (channels, options) ->
    @topic_url = options.forChannel.topicUrl()

  url: -> @topic_url + '/related_user_channels'
