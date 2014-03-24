ReactInput = React.createBackboneClass
  displayName: 'ReactInput'

  render: ->
    _div ['control-group'],
      _label ['control-label'],
        @props.label
      _div ['controls'],
        _input [
          type: @props.type
          value: @model().get(@props.attribute)
          onChange: (event) => @model().set @props.attribute, event.target.value
        ]

ReactSubmittableForm = React.createBackboneClass
  displayName: 'ReactSubmittableForm'

  _onSubmit: (e) ->
    e.preventDefault()
    @props.onSubmit() if @model().isValid()

  render: ->
    _form [
      onSubmit: @_onSubmit
    ],
      @props.children
      _div ['controls'],
        _button [
          'button-confirm'
          'controls-information-item'
          disabled: 'disabled' unless @model().isValid()
          onClick: @_onSubmit
        ],
          @props.label


window.ReactChangePassword = React.createClass
  displayName: 'ReactChangePassword'
  mixins: [UpdateOnSignInOrOutMixin]

  _submit: ->
    @props.model.save {},
      success: =>
        window.parent.FactlinkApp.NotificationCenter.success 'Your password has been changed!'
        @props.model.clear()
      error: ->
        window.parent.FactlinkApp.NotificationCenter.error 'Could not change your password, please try again.'

  render: ->
    return _span([], 'Please sign in.') unless FactlinkApp.signedIn()

    _div [],
      ReactUserTabs model: currentUser, page: 'change_password'
      _div ["edit-user-container"],
        _div ["narrow-indented-block"],
          ReactSubmittableForm {
            onSubmit: @_submit
            model: @props.model
            label: 'Change password'
          },
            ReactInput
              model: @props.model
              label: 'Current password'
              type: 'password'
              attribute: 'current_password'

            ReactInput
              model: @props.model
              label: 'New password'
              type: 'password'
              attribute: 'password'

            ReactInput
              model: @props.model
              label: 'Confirm new password'
              type: 'password'
              attribute: 'password_confirmation'
