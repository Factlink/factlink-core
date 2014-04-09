window.ReactSidebarLogin = React.createBackboneClass
  displayName: 'ReactSidebarLogin'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    if !currentSession.signedIn()
      ReactSigninLinks(className: "discussion-login")
    else
      _span []
