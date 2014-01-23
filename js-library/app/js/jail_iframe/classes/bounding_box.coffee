FactlinkJailRoot.drawBoundingBox = (box, color='green') ->
  coreContainerOffset = FactlinkJailRoot.$factlinkCoreContainer.offset()

  $boundingBox = $ """
    <div style="
      position: absolute; background-color: #{color};
      left: #{box.left-coreContainerOffset.left}px;
      top: #{box.top-coreContainerOffset.top}px;
      width: #{box.width}px; height: #{box.height}px;
      z-index: 100000000; visibility: visible; opacity: 0.3;
    "></div>
  """

  FactlinkJailRoot.$factlinkCoreContainer.append($boundingBox)

  $boundingBox
