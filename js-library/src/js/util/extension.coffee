Factlink.triggerClick = ->
  top = (window.innerHeight/2)-12 + window.pageYOffset
  left = (window.innerWidth/2)-39.5 + window.pageXOffset

  if Factlink.textSelected()
    Factlink.prepare.show(top, left)
    Factlink.prepare.startLoading()

    Factlink.createFactFromSelection()
  else
    select_text_message = new Factlink.Views.Notification
      message: 'To create a Factlink, select a statement and click the Factlink button.'
      type_classes: 'fl-message-icon-add'

    select_text_message.render()
