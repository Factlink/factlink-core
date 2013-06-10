Factlink.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if Factlink.textSelected()
    Factlink.prepare.show(top, left)
    Factlink.prepare.startLoading()

    Factlink.createFactFromSelection()
  else
    select_text_message = new Factlink.Views.Notification
      message: 'Please select text to create a Factlink'

    select_text_message.render()
