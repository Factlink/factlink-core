window.ReactGroupMembershipEdit = React.createBackboneClass
  displayName: 'ReactGroupMembershipEdit'
  mixins: [UpdateOnSignInOrOutMixin]


  render: ->
    return _span([], 'Please sign in.') unless currentSession.signedIn()

    _span [], "PLACEHOLDER"
