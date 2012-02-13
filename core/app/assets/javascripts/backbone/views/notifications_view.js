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

  setupNotificationsFetch: function () {
    var args = arguments;
    var self = this;

    this.collection.fetch({
      success: function () {
        setTimeout(function () {
          args.callee.apply(self, args);
        }, 7000);
      }
    });
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
    console.info( this );
    this.$el.find('ul').show();

    this._bindWindowClick();
  },

  hideDropdown: function () {
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