rightClick = (event=window.event) ->
  if event.which
    event.which == 3
  else if event.button
    event.button == 2
  else
    false

FACTLINK.textSelected = (e) ->
  FACTLINK.getSelectionInfo().text?.length > 1

timeout = null

FACTLINK.startAnnotating = ->
  console.info "FACTLINK:", "startAnnotating"

  $("body").bind "mouseup.factlink", (event) ->
    window.clearTimeout timeout
    if FACTLINK.prepare.isVisible()
      FACTLINK.prepare.hide()

    # We execute the showing of the prepare menu inside of a setTimeout
    # because of selection change only activating after mouseup event call.
    # Without this hack there are moments when the prepare menu will show
    # without any text being selected
    timeout = setTimeout(->
      return if rightClick(event)

      # Check if the selected text is long enough to be added
      if FACTLINK.textSelected() && !$(event.target).is(":input")
        FACTLINK.prepare.show event.pageY, event.pageX
        FACTLINK.trigger "textSelected"
    , 200)

FACTLINK.stopAnnotating = ->
  console.info "FACTLINK:", "stopAnnotating"
  FACTLINK.prepare.hide()
  $("body").unbind "mouseup.factlink"
