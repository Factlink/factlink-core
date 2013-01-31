class window.ExtensionButtonMimic extends Backbone.View
  id: "extension-button"
  events:
    "mousedown": "triggerClick"
    "mouseup": "unsetActive"
    "mouseover": "setHover"
    "mouseout": "unsetHover"

  triggerClick: ->
    @setActive()

    FACTLINK.triggerClick()

    false

  setActive: -> @$el.addClass "active"
  unsetActive: -> @$el.removeClass "active"
  setHover: -> @$el.addClass "hover"
  unsetHover: -> @$el.removeClass "hover"

  increaseCount: -> @$el.addClass "increased"
  decreaseCount: -> @$el.removeClass "increased"