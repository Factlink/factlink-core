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

    this.modelView = NotificationView;

    this.setupNotificationsFetch();

    this.$el.find('ul').preventScrollPropagation();
  },

  beforeReset: function () {
    this.setUnreadCount(0);
  },

  afterAdd: function (notification) {
    if ( notification.get('unread') === true ) {
      this.incrementUnreadCount();
    }
  },

  incrementUnreadCount: function () {
    this.setUnreadCount( this._unreadCount + 1 );
  },

  setUnreadCount: function (count) {
    var $unread = this.$el.find('.unread');
    this._unreadCount = count;

    $unread.text(this._unreadCount);

    if ( count > 0 ) {
      $unread.show();
    } else {
      $unread.hide();
    }
  },

  markAsRead: function () {
    this.collection.markAsRead({
      success: function () {
        this.setUnreadCount(0);
      }
    });
  },

  setupNotificationsFetch: function () {
    var args = arguments;
    var self = this;

    if ( ! this._visible ) {
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
    var self = this;
    var $dropdown = this.$el.find('ul');

    if ( ! $dropdown.is(':visible' ) ) {
      this.showDropdown();
    } else {
      this.hideDropdown();
    }

    e.stopPropagation();
  },

  showDropdown: function () {
    this._visible = true;

    this.$el.find('ul').show();

    this.markAsRead();

    this._bindWindowClick();
  },

  hideDropdown: function () {
    this._visible = false;

    this.$el.find('ul').hide();

    this._unbindWindowClick();
  },

  _bindWindowClick: function () {
    var self = this;

    $(window).on('click.notifications', function ( e ) {
      if ( ! $( e.target ).closest('ul').is('#notifications-dropdown') ) {
        self.hideDropdown();
      }
    })
  },

  _unbindWindowClick: function () {
    $(window).off('click.notifications');
  }
});
}());