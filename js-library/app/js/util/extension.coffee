Factlink.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if Factlink.textSelected()
    Factlink.createButton.setCoordinates(top, left)
    Factlink.createButton.show()
    Factlink.createButton.startLoading()

    Factlink.createFactFromSelection()
  else
    Factlink.Views.Notifications.showShouldSelectText()
