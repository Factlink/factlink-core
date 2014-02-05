FactlinkJailRoot.setElementPosition = (options) ->
  containerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()

  options.$el.css
    left: (options.left - containerOffset.left) + "px"
    top: (options.top - containerOffset.top) + "px"
