window.ReactSigninPopover = React.createClass
  getInitialState: ->
    opened: false
    callback: null

  componentDidMount: ->
    window.session.user().on 'change:username', @_onSignedInChange, @
    FactlinkApp.vent.on 'ReactSigninPopover:opened', @_onOtherPopoverOpened, @

  componentWillUnmount: ->
    window.session.user().off null, null, @
    FactlinkApp.vent.off null, null, @

  _onOtherPopoverOpened: (popover) ->
    return if popover == this

    @setState opened: false, callback: null

  _onSignedInChange: ->
    if FactlinkApp.signedIn() && @state.opened
      @state.callback()
      @setState opened: false, callback: null

    @forceUpdate()

  submit: (callback) ->
    if FactlinkApp.signedIn()
      callback()
    else
      if @state.opened
        @setState opened: false, callback: null
      else
        @setState opened: true, callback: callback
        FactlinkApp.vent.trigger 'ReactSigninPopover:opened', this

  render: ->
    if @state.opened && !FactlinkApp.signedIn()
      if window.localStorageIsEnabled
        ReactPopover className: 'white-popover', attachment: 'right',
          _span ["signin-popover"],
            'Sign in with: ',
            _a ["button-twitter small-connect-button js-accounts-popup-link",
              # The "?use_authorize=true&x_auth_access_type=write" part is for some weird twitter bug
              href: "/auth/twitter?use_authorize=true&x_auth_access_type=write"
            ],
              _i ["icon-twitter"]
            ' ',
            _a ["button-facebook small-connect-button js-accounts-popup-link",
              href: "/auth/facebook"
            ],
              _i ["icon-facebook"]
            ' ',
            _a ["js-accounts-popup-link",
              href: "/users/sign_in_or_up"
            ],
              "or sign in/up with email."
      else
        ReactPopover className: 'white-popover', attachment: 'right',
          _p ["signin-popover"],
              "Your privacy settings block you from interacting."
              _br {}
              " Please enable (third-party) cookies from factlink.com"
    else
      _span()
