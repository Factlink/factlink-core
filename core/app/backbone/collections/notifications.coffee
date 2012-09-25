class window.Notifications extends Backbone.Collection
  model: Notification
  url: -> "/" + currentUser.get("username") + "/activities"

  unreadCount: ->
    unreads = _.reject this.pluck('unread'),
      (item)-> !item
    unreads.length

  markAsRead: (opts = {}) ->

    $.ajax({
      url: @url() + "/mark_as_read",
      type: "POST",
      success: -> opts.success.apply(this, arguments) if ( typeof opts.success == "function" )
      error: -> opts.error.apply(this, arguments) if ( typeof opts.error == "function" )
    });

