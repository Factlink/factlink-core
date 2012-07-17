class window.AutoCompletedAddedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a.icon-remove": "remove"

  template: "channels/_auto_completed_added"