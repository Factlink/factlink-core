FactlinkJailRoot.contentBox = (element) ->
  $element = $(element)
  offset = $element.offset()

  top: offset.top + parseInt window.getComputedStyle(element)['padding-top']
  left: offset.left + parseInt window.getComputedStyle(element)['padding-left']
  width: $element.width()
  height: $element.height()
