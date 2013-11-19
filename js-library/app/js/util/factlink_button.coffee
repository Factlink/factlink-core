Factlink.initializeFactlinkButton = ->
  $(document).on "click", ".js-factlink-create-button", (e) ->
    e.preventDefault()
    e.stopPropagation()
    Factlink.triggerClick()

  $(document).on "mousedown", ".js-factlink-create-button", (e) ->
    # prevent mousedown from deselecting the text that
    # the button is intended to use:
    e.preventDefault()
