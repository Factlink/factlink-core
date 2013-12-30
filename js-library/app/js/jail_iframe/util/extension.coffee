FactlinkJailRoot.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if FactlinkJailRoot.textSelected()
    FactlinkJailRoot.createButton.placeNearSelection()
    FactlinkJailRoot.createButton.show()
    FactlinkJailRoot.createButton.startLoading()

    FactlinkJailRoot.createFactFromSelection()
  else
    FactlinkJailRoot.showShouldSelectTextNotification()
