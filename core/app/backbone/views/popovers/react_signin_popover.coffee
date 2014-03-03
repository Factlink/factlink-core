window.ReactSigninPopover = React.createClass
  getInitialState: ->
    opened: false

  componentDidMount: ->
    window.currentUser.on 'change:username', @_onSignedInChange, @

  componentWillUnmount: ->
    window.currentUser.off null, null, @

  _onButtonClicked: (e) ->
    @setState opened: true

  _onSignedInChange: ->
    if FactlinkApp.signedIn() && @state.opened
      @props.onSubmit?()
      @setState opened: false

    @forceUpdate()

  submit: ->
    if FactlinkApp.signedIn()
      @props.onSubmit?()
    else
      @setState opened: !@state.opened

  render: ->
    if @state.opened && !FactlinkApp.signedIn()
      if window.localStorageIsEnabled
        ReactPopover className: 'white-popover', attachment: 'right',
          _span ["signin-popover"],
            _a ["button-twitter small-connect-button js-accounts-popup-link",
              href: "/auth/twitter"
              onMouseDown: @_onButtonClicked
            ],
              _i ["icon-twitter"]
            ' ',
            _a ["button-facebook small-connect-button js-accounts-popup-link",
              href: "/auth/facebook"
              onMouseDown: @_onButtonClicked
            ],
              _i ["icon-facebook"]
            ' ',
            _a ["js-accounts-popup-link",
              href: "/users/sign_in_or_up"
              onMouseDown: @_onButtonClicked
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
