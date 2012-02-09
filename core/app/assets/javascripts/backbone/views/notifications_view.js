(function(){
window.NotificationsView = Backbone.View.extend({
  tagName: "a",
  className: "notifications",

  _unreadCount: 0,

  events: {
    "click": "clickHandler"
  },

  initialize: function () {
    this.collection.on("add", this.addOne, this);
    this.collection.on("reset", this.reset, this);

    this.setupNotificationsFetch();
  },

  addOne: function (notification) {
    if ( notification.get("unread") === true ) {
      this._unreadCount += 1;
    }
  },

  reset: function () {

  },

  setupNotificationsFetch: function () {
    var args = arguments;
    var self = this;

    setTimeout(function() {
      false && self.collection.fetch({
        success: function() {
          args.callee();
        }
      });
    }, 7000);
  },

  clickHandler: function (e) {
    this.collection.markAsRead();
  }
});
}());