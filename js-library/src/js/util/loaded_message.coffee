showLoadedMessage = ->
  loaded_message = new Factlink.Views.Notification
    message: 'Factlink is loaded!'
    type_classes: 'fl-message-success fl-message-icon-time'

  loaded_message.render()

$(window).on 'factlink.factsLoaded', ->
  if FactlinkConfig?.client == 'bookmarklet'
    showLoadedMessage()
