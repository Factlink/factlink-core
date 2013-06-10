showLoadedMessage = ->
  loaded_message = new Factlink.Views.Notification
    message: 'Factlink is loaded'

  loaded_message.render()

$(window).on 'factlink.factsLoaded', ->
  if FactlinkConfig?.client == 'bookmarklet'
    showLoadedMessage()
