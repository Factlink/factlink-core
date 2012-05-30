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

  tmpl: Template.use("notifications", "_notifications"),

  initialize: function () {
    this.collection.on("add", this.add, this);
    this.collection.on("reset", this.reset, this);

    this.modelView = NotificationView;
    this.setupNotificationsFetch();
  },

  render: function() {
    this.$el.find("ul.dropdown-menu").html(this.tmpl.render());

    if (this.collection.length === 0){
      this.$el.find("li.no-notifications").removeClass('hidden');
    }else{
      this.$el.find("li.no-notifications").addClass('hidden');
      Backbone.CollectionView.prototype.render.apply(this, arguments);
    }
    this.$el.find('ul').preventScrollPropagation();
    return this;
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
    this.$el.css({'visibility':'visible'});
    this._unreadCount = count;
    this._unreadTitleCount = count;

    if ( count > 0 ) {
      $unread.addClass('active');
    } else {
      $unread.removeClass('active');
    }

    if ( count > 9 ) {
      this._unreadCount = "9<sup>+</sup>";
      this._unreadTitleCount = "9+";
    }

    $unread.html(this._unreadCount);


    var $factlink_page_title = "Factlink - Because the web needs what you know";
    if ( count > 0 ) {
      document.title = "(" + this._unreadTitleCount + ") " + $factlink_page_title;
    } else {
      document.title = $factlink_page_title;
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

    if ( ! this._visible ) {
      this.collection.fetch({
        success: function () {
          setTimeout(function () {
            if ( typeof localStorage === "object"
              && localStorage !== null
              && localStorage['reload'] === "false" ) {
              return;
            }

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
    if ( this._visible ) {
      this.hideDropdown();
    } else {
      this.showDropdown();
    }

    e.stopPropagation();
  },

  showDropdown: function () {
    this._visible = true;

    this.$el
      .addClass('open')
      .find('ul').show();

    this.markAsRead();

    this._bindWindowClick();
  },

  hideDropdown: function () {
    this._visible = false;

    this.$el
      .removeClass("open")
      .find('ul').hide();

    if ( this._shouldMarkUnread === true ) {
      this._shouldMarkUnread = false;

      _.forEach(this.views, function ( view ) {
        view.markAsRead();
      });
    }

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
