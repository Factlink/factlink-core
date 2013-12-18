FactlinkJailRoot.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if FactlinkJailRoot.textSelected()
    console.log 'weirdness'
    FactlinkJailRoot.createButton.setCoordinates(top, left)
    FactlinkJailRoot.createButton.show()
    FactlinkJailRoot.createButton.startLoading()

    FactlinkJailRoot.createFactFromSelection()
  else
    FactlinkJailRoot.showShouldSelectTextNotification()
