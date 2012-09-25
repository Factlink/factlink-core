class window.OwnChannelCollection extends Backbone.Collection
  model: Channel
  url: -> '/' + currentUser.get('username') + '/channels'