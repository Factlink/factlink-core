class window.Notifications extends Backbone.Collection
  model: Notification
  url: -> "/" + currentUser.get("username") + "/activities"

  unreadCount: ->
    unreads = _.reject @pluck('unread'), (item) -> !item
    unreads.length

  markAsRead: (options = {}) ->
    Backbone.ajax _.extend {}, options,
      url: @url() + "/mark_as_read"
      type: "POST"
