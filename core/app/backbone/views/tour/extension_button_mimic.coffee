class window.ExtensionButtonMimic extends Backbone.View
  id: "extension-button"
  events:
    "mousedown": "triggerClick"

  triggerClick: ->
    FACTLINK.triggerClick()

    false