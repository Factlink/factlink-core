window.AutoCompletedAddedChannelView = Backbone.Marionette.ItemView.extend(
  tagName: "li"

  triggers:
    "click a": "remove"

  template: "channels/_auto_completed_added"
)
