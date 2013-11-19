Factlink.initializeFactlinkButton = ->
  $(document).on "click", ".factlink-create-button", (e) ->
    e.preventDefault()
    e.stopPropagation()
    Factlink.triggerClick()

  $(document).on "mousedown", ".factlink-create-button", (e) ->
    # prevent mousedown from deselecting the text that
    # the button is intended to use:
    e.preventDefault()
