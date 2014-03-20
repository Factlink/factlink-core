window.ReactChangePassword = React.createBackboneClass
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    current_password: ''
    password: ''
    password_confirmation: ''

  _valid: ->
    @state.current_password.length > 0 &&
      @state.password.length >= 6 && # seems to be enforced by devise
      @state.password_confirmation == @state.password

  _submit: ->
    return unless @_valid()

    currentUser.change_password @state, => @setState @getInitialState()

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
            value: @state.current_password
            onChange: (event) => @setState current_password: event.target.value
          ]

          _label [],
            'New password'
          _input [
            type: 'password'
            value: @state.password
            onChange: (event) => @setState password: event.target.value
          ]

          _label [],
            'Confirm new password'
          _input [
            type: 'password'
            value: @state.password_confirmation
            onChange: (event) => @setState password_confirmation: event.target.value
          ]

          _div [],
            _button [
              'button-confirm'
              disabled: 'disabled' unless @_valid()
              onClick: @_submit
            ],
              'Change password'
