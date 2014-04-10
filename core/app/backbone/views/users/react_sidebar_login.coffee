window.ReactSidebarLogin = React.createBackboneClass
  displayName: 'ReactSidebarLogin'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    if !currentSession.signedIn()
      ReactSigninLinks()
    else
      _span []
