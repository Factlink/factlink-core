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

Factlink.startAnnotating = ->
  console.info "Factlink:", "startAnnotating"

  $("body").bind "mouseup.factlink", (event) ->
    window.clearTimeout timeout
    if Factlink.prepare.isVisible()
      Factlink.prepare.hide()

    # We execute the showing of the prepare menu inside of a setTimeout
    # because of selection change only activating after mouseup event call.
    # Without this hack there are moments when the prepare menu will show
    # without any text being selected
    timeout = setTimeout(->
      return if rightClick(event)

      # Check if the selected text is long enough to be added
      if Factlink.textSelected() && !$(event.target).is(":input")
        Factlink.prepare.show event.pageY, event.pageX
        Factlink.trigger "textSelected"
    , 200)

Factlink.stopAnnotating = ->
  console.info "Factlink:", "stopAnnotating"
  Factlink.prepare.hide()
  $("body").unbind "mouseup.factlink"
