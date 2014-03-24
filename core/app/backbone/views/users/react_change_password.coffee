window.ReactChangePassword = React.createBackboneClass
  mixins: [UpdateOnSignInOrOutMixin]

  _submit: ->
    @model().save {},
      success: =>
        window.parent.FactlinkApp.NotificationCenter.success 'Your password has been changed!'
        @model().clear()
      error: ->
        window.parent.FactlinkApp.NotificationCenter.error 'Could not change your password, please try again.'

  render: ->
    return _span() unless FactlinkApp.signedIn()

    _div [],
      ReactUserTabs model: currentUser, page: 'change_password'
      _div ["edit-user-container"],
        _div ["narrow-indented-block"],
          _label [],
            'Current password'
          _input [
            type: 'password'
            value: @model().get('current_password')
            onChange: (event) => @model().set 'current_password', event.target.value
          ]

          _label [],
            'New password'
          _input [
            type: 'password'
            value: @model().get('password')
            onChange: (event) => @model().set 'password', event.target.value
          ]

          _label [],
            'Confirm new password'
          _input [
            type: 'password'
            value: @model().get('password_confirmation')
            onChange: (event) => @model().set 'password_confirmation', event.target.value
          ]

          _div [],
            _button [
              'button-confirm'
              disabled: 'disabled' unless @model().isValid()
              onClick: @_submit
            ],
              'Change password'
