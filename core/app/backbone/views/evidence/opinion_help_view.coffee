window.ReactOpinionHelp = React.createClass
  render: ->
    _div ['add-evidence-form'],
      _span ["add-evidence-arrow"]
      _div ['opinion-help'],
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
