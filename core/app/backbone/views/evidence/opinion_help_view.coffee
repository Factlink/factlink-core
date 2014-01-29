window.ReactOpinionHelp = React.createClass
  render: ->
    R.div className: 'opinion-help',
      R.div className: 'discussion-evidenceish-content',
        R.span className: "js-question opinion-help-question",
          "What do you think?"
        R.a href: "/auth/twitter", className: "button button-twitter small-connect-button opinion-help-button js-accounts-popup-link",
          R.i className: "icon-twitter"
        R.a href: "/auth/facebook", className: "button button-facebook small-connect-button opinion-help-button js-accounts-popup-link",
          R.i className: "icon-facebook"
        R.a href: "/users/sign_in_or_up", className: "js-accounts-popup-link",
          "or sign in/up with email."
