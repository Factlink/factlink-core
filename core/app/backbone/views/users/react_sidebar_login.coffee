window.ReactSidebarLogin = React.createBackboneClass
  displayName: 'ReactSidebarLogin'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    if !currentSession.signedIn()
      ReactSigninLinks
        className: 'discussion-login'
        buttonClassName: 'button-connect-small'
    else
      _span []
