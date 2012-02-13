(function(){
window.NotificationsView = Backbone.CollectionView.extend({
  views: {},

  tagName: "li",
  id: "notifications",
  containerSelector: "ul",

  _unreadCount: 0,

  events: {
    "click": "clickHandler"
  },

  initialize: function () {
    this.collection.on("add", this.add, this);
    this.collection.on("reset", this.reset, this);

    this.modelView = NotificationItemView;

    this.setupNotificationsFetch();
  },

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