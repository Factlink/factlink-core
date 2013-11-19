rightClick = (event=window.event) ->
  if event.which
    event.which == 3
  else if event.button
    event.button == 2
  else
    false

Factlink.textSelected = (e) ->
  Factlink.getSelectionInfo().text?.length > 1

timeout = null

annotating = false

Factlink.startAnnotating = ->
  return if annotating
  annotating = true

  console.info "Factlink:", "startAnnotating"

  $("body").bind "mouseup.factlink", (event) ->
    window.clearTimeout timeout
    Factlink.createButton.hide()

    if $('.js-factlink-create-button').length
      return

    # We execute the showing of the prepare menu inside of a setTimeout
    # because of selection change only activating after mouseup event call.
    # Without this hack there are moments when the prepare menu will show
    # without any text being selected
    timeout = setTimeout(->
      return if rightClick(event)

      # Check if the selected text is long enough to be added
      if Factlink.textSelected() && !$(event.target).is(":input")
        Factlink.createButton.setCoordinates event.pageY, event.pageX
        Factlink.createButton.show()
        Factlink.trigger "textSelected"
    , 200)

Factlink.stopAnnotating = ->
  return unless annotating
  annotating = false

  console.info "Factlink:", "stopAnnotating"
  Factlink.createButton.hide()
  $("body").unbind "mouseup.factlink"
