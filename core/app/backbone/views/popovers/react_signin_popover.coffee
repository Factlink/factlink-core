window.ReactSigninLinks = React.createClass
  displayName: "ReactSigninLinks"

  render: ->
    if window.localStorageIsEnabled
      _div [],
        _span ["signin-popover"],
          'Sign in with: ',
          _a ["button-twitter small-connect-button js-accounts-popup-link",
            href: "/auth/twitter"
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
      _div [],
        _p ["signin-popover"],
            "Your privacy settings block you from interacting."
            _br {}
            " Please enable (third-party) cookies from factlink.com"


window.ReactSigninPopover = React.createClass
  getInitialState: ->
    opened: false
    callback: null

  componentDidMount: ->
    window.currentSession.user().on 'change:username', @_onSignedInChange, @
    Factlink.vent.on 'ReactSigninPopover:opened', @_onOtherPopoverOpened, @

  componentWillUnmount: ->
    window.currentSession.user().off null, null, @
    Factlink.vent.off null, null, @

  _onOtherPopoverOpened: (popover) ->
    return if popover == this

    @setState opened: false, callback: null

  _onSignedInChange: ->
    if currentSession.signedIn() && @state.opened
      @state.callback()
      @setState opened: false, callback: null
      mp_track "Sign in with Popover"

    @forceUpdate()

  submit: (callback) ->
    if currentSession.signedIn()
      callback()
    else
      if @state.opened
        @setState opened: false, callback: null
      else
        @setState opened: true, callback: callback
        Factlink.vent.trigger 'ReactSigninPopover:opened', this

  render: ->
    if @state.opened && !currentSession.signedIn()
      ReactPopover className: 'white-popover', attachment: 'right',
        ReactSigninLinks()
    else
      _span()
