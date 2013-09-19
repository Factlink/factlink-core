Factlink.createButton = new Factlink.CreateButton
  mouseup: (e) -> e.stopPropagation()
  mousedown: (e) -> e.preventDefault() # To prevent de-selecting text
  click: (e) ->
    e.preventDefault()
    e.stopPropagation()
    Factlink.createButton.startLoading()
    Factlink.createFactFromSelection()
