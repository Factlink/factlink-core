Factlink.createButton = new Factlink.CreateButton
  mousedown: (e) -> e.preventDefault() # To prevent de-selecting text
  click: (e) ->
    e.preventDefault()
    Factlink.createButton.startLoading()
    Factlink.createFactFromSelection()
