window.OwnChannelCollection = Backbone.Collection.extend({
  model: Channel,
  url: function() {
    return '/' + currentUser.get('username') + '/channels/';
  }
});