class window.WindowTitle extends Backbone.Model
  totalUnreadCount: () -> @get('notificationsCount') || 0
