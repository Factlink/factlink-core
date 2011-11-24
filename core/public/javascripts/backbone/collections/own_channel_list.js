window.OwnChannelList = ChannelList.extend({
  url: function() {
    return '/' + currentUser.get('username') + '/channels/';
  }
});