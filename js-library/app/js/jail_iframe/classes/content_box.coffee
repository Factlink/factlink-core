FactlinkJailRoot.contentBox = (element) ->
  $element = $(element)
  offset = $element.offset()

  top: offset.top + parseInt getComputedStyle(element)['padding-top']
  left: offset.left + parseInt getComputedStyle(element)['padding-left']
  width: $element.width()
  height: $element.height()
