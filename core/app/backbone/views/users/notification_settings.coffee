class window.NotificationSettingsView extends Backbone.Marionette.ItemView
  template: 'users/notification_settings'

  modelBindings:
    "change input.send_mail" : 'receives_mailed_notifications'
    "change input.send_mail2" : 'receives_mailed_notifications'

  onRender: -> @bind()

  onBindChange: ->
    @model.save [],
      error: -> FactlinkApp.NotificationCenter.error 'Something went wrong while saving your preferences'

_.extend window.NotificationSettingsView.prototype, Backbone.Factlink.ModelBinding
