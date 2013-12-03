FactlinkJailRoot.createButton = new FactlinkJailRoot.CreateButton
  mousedown: (e) -> e.preventDefault() # To prevent de-selecting text
  click: (e) ->
    FactlinkJailRoot.createButton.startLoading()
    FactlinkJailRoot.createFactFromSelection()
