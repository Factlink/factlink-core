(function() {

window.TitleView = Backbone.View.extend({

  initialize: function(opts) {
    this.model.on('change', this.render, this);
    this.collection.on('reset', this.setChannelUnread, this);
  },

  render: function() {
    document.title = (this.countString() + this.factlinkTitle());
  },

  factlinkTitle: function(){
    return "Factlink — Because the web needs what you know";
  },

  countString: function() {
    var notificationsCount = this.model.get('notificationsCount') || 0;
    var channelUnreadCount = this.model.get('channelUnreadCount') || 0;

    var count = notificationsCount + channelUnreadCount;

    if (count > 0) {
      return "(" + count + ") ";
    } else {
      return "";
    }
  },

  setChannelUnread: function(collection) {
    this.model.set('channelUnreadCount', collection.unreadCount());
  }
});

}());
