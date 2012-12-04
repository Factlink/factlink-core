class window.SuggestedChannels extends Backbone.Collection
  model: Channel

  url: -> "/u/channel_suggestions"
