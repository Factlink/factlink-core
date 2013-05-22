class window.NotificationSettingsView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.ModelBinding
  template: 'users/notification_settings'

  modelBindings:
    "change input.js-receives-mailed-notifications" : 'receives_mailed_notifications'
    "change input.js-receives-digest" : 'receives_digest'

  onRender: -> @bind()

  onBindChange: ->
    @model.save [],
      error: -> FactlinkApp.NotificationCenter.error 'Something went wrong while saving your preferences'

