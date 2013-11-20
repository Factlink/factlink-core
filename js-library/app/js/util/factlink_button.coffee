Factlink.initializeFactlinkButton = ->
  buttonSel = ".js-factlink-create-button"

  $(document).on "click", buttonSel, (e) ->
    e.preventDefault()
    e.stopPropagation()
    Factlink.triggerClick()

  $(document).on "mousedown", buttonSel, (e) ->
    # prevent mousedown from deselecting the text that
    # the button is intended to use:
    e.preventDefault()

  setTitle = ->
    $(buttonSel)
      .attr('title', 'Select any statement in this article and click this button to add your opinion.')
      .length > 0
  setTitle() || $ setTitle
