NotificationSetting = React.createBackboneClass
  toggle: ->
    @model().set @props.field, !@model().get(@props.field)
    @model().save [],
      error: -> Factlink.notificationCenter.error 'Something went wrong while saving your preferences'

  render: ->
    _label [],
      _input [
        type:"checkbox",
        checked: @model().get(@props.field),
        onChange: @toggle
      ]
      @props.children...

window.ReactNotificationSettings = React.createBackboneClass
  render: ->
    _div [],
      ReactUserTabs model: @model(), page: 'notification-settings'
      _div ["edit-user-container"],
        _div ["narrow-indented-block"],
          NotificationSetting {field: 'receives_mailed_notifications', model: @model(), key: 'receives_mailed_notifications'},
            "Send me an email when I receive a notification"
          NotificationSetting {field: 'receives_digest', model: @model(), key: 'receives_digest'},
            "Send me a weekly digest "
            _em [], "(coming soon)"


