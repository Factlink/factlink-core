class window.OwnChannelCollection extends window.ChannelList
  model: Channel
  url: -> '/' + currentUser.get('username') + '/channels'