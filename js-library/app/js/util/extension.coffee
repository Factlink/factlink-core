FACTLINK.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if FACTLINK.textSelected()
    FACTLINK.prepare.show(top, left)
    FACTLINK.prepare.startLoading()

    FACTLINK.createFactFromSelection()
  else
    FACTLINK.Views.Notifications.showShouldSelectText()
