ReactSocialConnect = React.createBackboneClass
  displayName: 'ReactSocialConnect'

  render: ->
    _div [],
      _div ['control-group'],
        _label [],
          _span ['control-label'],
            'Facebook'
          _div ['controls'],
            if @model().get('services').facebook
              _span [],
                _i ["icon-ok"]
                ' Connected to Facebook. '
                _a ['control-error', href: '/auth/facebook/deauthorize', 'data-method': 'delete'],
                  '(Disconnect)'
            else
              _a ["button-facebook js-accounts-popup-link",
                href: "/auth/facebook"
              ],
                _i ["icon-facebook"]
                ' Connect with Facebook'

      _div ['control-group'],
        _label [],
          _span ['control-label'],
            'Twitter'
          _div ['controls'],
            if @model().get('services').twitter
              _span [],
                _i ["icon-ok"]
                ' Connected to Twitter. '
                _a ['control-error', href: '/auth/twitter/deauthorize', 'data-method': 'delete'],
                  '(Disconnect)'
            else
              _a ["button-twitter js-accounts-popup-link",
                # The "?use_authorize=true&x_auth_access_type=write" part is for some weird twitter bug
                href: "/auth/twitter?use_authorize=true&x_auth_access_type=write"
              ],
                _i ["icon-twitter"]
                ' Connect with Twitter'


ReactDeleteProfile = React.createClass
  displayName: 'ReactDeleteProfile'

  getInitialState: ->
    opened: false
    password: ''

  _onSubmit: ->
    currentSession.user().delete
      password: @state.password
      success: ->
        window.location = '/users/deleted'
      error: =>
        Factlink.notificationCenter.error 'Your account could not be deleted. Did you enter the correct password?'

  render: ->
    _div [],
      _a [
        'profile-edit-delete-link'
        onClick: => @setState opened: !@state.opened
      ],
        'Delete account'

      if @state.opened
        _div [],
          _div ['controls controls-information-item'],
            'Fill in your password to confirm deleting your account.'

          _div ['control-group'],
            _label [],
              _span ['control-label'],
                'Password'
              _div ['controls'],
                _input [
                  'spec-delete-password'
                  id: 'password'
                  type: 'password'
                  onChange: (event) => @setState password: event.target.value
                ]

                _div ['controls-information-item'],
                  _a [href: '/users/password/new'],
                    'Forgot your password?'

          _div ['controls'],
            _button [
              'button-danger'
              'controls-information-item'
              disabled: 'disabled' if @state.password.length == 0
              onClick: @_onSubmit
            ],
              'Delete my entire account'

            _div ['controls-information-item'],
              'Warning: all your data will be deleted!'


window.ReactProfileEdit = React.createBackboneClass
  displayName: 'ReactProfileEdit'
  mixins: [UpdateOnSignInOrOutMixin]

  componentWillMount: ->
    @_modelClone = @model().clone()
    @model().on 'change', (-> @_modelClone.set @model().attributes), @

  componentWillUnmount: ->
    @model().off 'change', null, @

  _submit: ->
    @model().save @_modelClone.attributes,
      success: =>
        Factlink.notificationCenter.success 'Your profile has been updated!'
      error: =>
        Factlink.notificationCenter.error 'Could not update your profile, please try again.'

  render: ->
    return _span([], 'Please sign in.') unless currentSession.signedIn()

    _div [],
      ReactUserTabs model: currentSession.user(), page: 'edit'
      _div ["edit-user-container"],
        _div ["narrow-indented-block"],
          ReactSubmittableForm {
            onSubmit: @_submit
            model: @_modelClone
            label: 'Save settings'
          },
            ReactInput
              model: @_modelClone
              label: 'Full name'
              attribute: 'full_name'

            ReactInput
              model: @_modelClone
              label: 'Location'
              attribute: 'location'

            ReactInput
              model: @_modelClone
              label: 'Bio'
              attribute: 'biography'

            _div ['control-group'],
              _label [],
                _span ['control-label'],
                  'Picture'
                _div ['controls'],
                  _img [
                    "image-80px avatar-container--large-avatar"
                    style: {float: 'left', 'margin-right': '10px'}
                    alt: " "
                    src: @model().avatar_url(80)
                  ]

                  "This image is automatically grabbed from #{@model().get('avatar_type')}. "
                  "Edit your #{@model().get('avatar_type')} account to edit the profile picture. "
                  if @model().get('avatar_type') == 'Gravatar'
                    "We use #{@model().get('email')}"

            ReactInput {
              model: @model()
              label: 'Email'
              attribute: 'email'
              disabled: 'disabled'
              className: 'profile-edit-email-disabled'
            },
              'To change your email address, please '
              _a [href: 'mailto:' + Factlink.Global.support_email], 'contact us'
              '.'

          _hr []

          ReactSocialConnect
            model: @model()

          _hr []

          ReactDeleteProfile {}
