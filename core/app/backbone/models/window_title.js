window.WindowTitle = Backbone.Model.extend({
  totalUnreadCount: function(){
    var notificationsCount = this.get('notificationsCount') || 0;
    var channelUnreadCount = this.get('channelUnreadCount') || 0;

    return notificationsCount + channelUnreadCount;
  }
});