class window.Notifications extends Backbone.Collection
  model: Notification
  url: -> "/" + currentUser.get("username") + "/activities"

  unreadCount: ->
    unreads = _.reject this.pluck('unread'),
      (item)-> !item
    unreads.length

  markAsRead: (options = {}) ->
    $.ajax _.extend {}, options,
      url: @url() + "/mark_as_read"
      type: "POST"
