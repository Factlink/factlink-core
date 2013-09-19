Factlink.createButton = new Factlink.CreateButton
  mousedown: (e) -> e.preventDefault() # To prevent de-selecting text
  click: (e) ->
    Factlink.createButton.startLoading()
    Factlink.createFactFromSelection()
