window.ReactSidebarLogin = React.createBackboneClass
  displayName: 'ReactSidebarLogin'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    if !currentSession.signedIn()
      _div ['discussion-login'],
        ReactSigninLinks buttonClassName: 'button-connect-small'
    else
      _span []
