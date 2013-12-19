rightClick = (event=window.event) ->
  if event.which
    event.which == 3
  else if event.button
    event.button == 2
  else
    false

FactlinkJailRoot.textSelected = (e) ->
  FactlinkJailRoot.getSelectionInfo().text?.length > 1

timeout = null

annotating = false

FactlinkJailRoot.startAnnotating = ->
  return if annotating
  annotating = true

  console.info "FactlinkJailRoot:", "startAnnotating"

  $("body").on "mouseup.factlink", (event) ->
    window.clearTimeout timeout
    FactlinkJailRoot.createButton.hide()

    if $('.js-factlink-create-button').length
      return

    # We execute the showing of the prepare menu inside of a setTimeout
    # because of selection change only activating after mouseup event call.
    # Without this hack there are moments when the prepare menu will show
    # without any text being selected
    timeout = setTimeout(->
      return if rightClick(event)

      # Check if the selected text is long enough to be added
      if FactlinkJailRoot.textSelected() && !$(event.target).is(":input")
        FactlinkJailRoot.createButton.setCoordinates event.pageY, event.pageX
        FactlinkJailRoot.createButton.show()
        FactlinkJailRoot.trigger "textSelected"
    , 200)

FactlinkJailRoot.stopAnnotating = ->
  return unless annotating
  annotating = false

  console.info "FactlinkJailRoot:", "stopAnnotating"
  FactlinkJailRoot.createButton.hide()
  $("body").off "mouseup.factlink"
