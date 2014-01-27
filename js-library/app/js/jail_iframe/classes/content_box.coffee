FactlinkJailRoot.contentBox = (element) ->
  $element = $(element)
  offset = $element.offset()

  top: offset.top + parseInt window.getComputedStyle(element).paddingTop
  left: offset.left + parseInt window.getComputedStyle(element).paddingLeft
  width: $element.width()
  height: $element.height()
