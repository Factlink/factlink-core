(function(){
window.NotificationsView = Backbone.CollectionView.extend({
  views: {},

  tagName: "li",
  id: "notifications",
  containerSelector: "ul",

  _unreadCount: 0,

  initialize: function () {
    var self = this;

    this.collection.on("add", this.add, this);
    this.collection.on("reset", this.reset, this);

    this.modelView = NotificationView;

    //this.setupNotificationsFetch();

    this.$el.find('ul').preventScrollPropagation();

    // We need this click handler to be attached here, because
    // Bootstrap.dropdown() has a return false; which makes the event not bubble.
    // And Backbone.events doesn't bind directly on the element.
    //this.$el.find(">a").on("click", $.proxy(this.clickHandler, this));
    this.$el.hide();
  },

  beforeReset: function () {
    this.setUnreadCount(0);
  },

  afterAdd: function (notification) {
    if ( notification.get('unread') === true ) {
      this.setUnreadCount( this._unreadCount + 1 );
    }
  },

  setUnreadCount: function (count) {
    var $unread = this.$el.find('span.unread');
    this._unreadCount = count;

    $unread.text(this._unreadCount);

    if ( count > 0 ) {
      $unread.show();
    } else {
      $unread.hide();
    }
  },

  markAsRead: function () {
    var self = this;

    this.collection.markAsRead({
      success: function () {
        self.markViewsForUnreadification();
        self.setUnreadCount(0);
      }
    });
  },

  markViewsForUnreadification: function () {
    this._shouldMarkUnread = true;
  },

  setupNotificationsFetch: function () {
    var args = arguments;
    var self = this;

    if ( ! this.$el.find("ul").is(":visible") ) {
      this.collection.fetch({
        success: function () {
          setTimeout(function () {
            args.callee.apply(self, args);
          }, 7000);
        }
      });
    } else {
      setTimeout(function () {
        args.callee.apply(self, args);
      }, 7000);
    }
  },

  clickHandler: function (e) {
    if ( this.$el.find("ul").is(":visible") ) {
      this.markAsRead();
    } else if ( this._shouldMarkUnread === true ) {
      this._shouldMarkUnread = false;

      _.forEach(this.views, function ( view ) {
        view.markAsRead();
      });
    }
  }
});
}());
