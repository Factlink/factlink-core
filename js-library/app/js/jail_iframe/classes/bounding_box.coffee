FactlinkJailRoot.drawBoundingBox = (options) ->
  coreContainerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()

  $boundingBox = $ """
    <div style="
      position: absolute; background-color: #{options.color || 'red'};
      left: #{options.left-coreContainerOffset.left}px;
      top: #{options.top-coreContainerOffset.top}px;
      width: #{options.width}px; height: #{options.height}px;
      z-index: 100000000; visibility: visible; opacity: 0.3;
    "></div>
  """

  FactlinkJailRoot.$factlinkCoreContainer.append($boundingBox)

  $boundingBox
