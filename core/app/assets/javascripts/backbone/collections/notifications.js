(function(){
window.Notifications = Backbone.Collection.extend({
  model: Notification,
  url: function() {
    return currentUser.get("username") + "/activities";
  },

  markAsRead: function(opts) {
    if ( !opts ) { opts = {} };

    $.ajax({
      url: this.url() + "/mark_as_read",
      type: "POST",
      success: function() {
        if ( typeof opts.success === "function" ) {
          opts.success.apply(this, arguments);
        }
      },
      error: function() {
        if ( typeof opts.error === "function" ) {
          opts.error.apply(this, arguments);
        }
      }
    });
  }
});
}());