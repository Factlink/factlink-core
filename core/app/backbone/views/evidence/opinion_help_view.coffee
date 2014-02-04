window.ReactOpinionHelp = React.createClass
  displayName: 'ReactOpinionHelp'

  render: ->
    _div ['opinion-help'],
      _div [],
        _span ["opinion-help-question"],
          "What do you think?"
        _a ["button button-twitter small-connect-button opinion-help-button js-accounts-popup-link",
          href: "/auth/twitter"],
            _i ["icon-twitter"]
        _a ["button button-facebook small-connect-button opinion-help-button js-accounts-popup-link",
          href: "/auth/facebook"],
          _i ["icon-facebook"]
        _a ["js-accounts-popup-link", href: "/users/sign_in_or_up"],
          "or sign in/up with email."
