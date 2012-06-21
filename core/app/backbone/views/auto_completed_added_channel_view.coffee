class window.AutoCompletedAddedChannelView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a": "remove"

  template: "channels/_auto_completed_added"