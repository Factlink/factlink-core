(function() {

window.TitleManagerView = Backbone.View.extend({

  initialize: function(opts) {
    this.model.on('change', this.render, this);
    window.Channels.on('reset', this.setChannelUnread, this);
  },

  render: function() {
    document.title = this.buildTitle();
  },

  buildTitle: function() {
    var notificationsCount = this.model.get('notificationsCount') || 0;
    var channelUnreadCount = this.model.get('channelUnreadCount') || 0;

    var count = notificationsCount + channelUnreadCount;

    // Hoi Mark dit mag je een keertje refactoren. Het is 18.26 dus ik ga naar huis. Doeg.
    if (count > 0) {
      count = "(" + count + ") ";
    } else {
      count = "";
    }

    return count + "Factlink — Because the web needs what you know";
  },

  setChannelUnread: function(collection) {
    var count = collection.reduce(function(memo, channel) {
      return memo + channel.get('unread_count');
    }, 0);

    TitleManager.set('channelUnreadCount', count);
  }
});

new TitleManagerView({
  model: new Backbone.Model()
});

}());
