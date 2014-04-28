window.ReactGroupMembershipEdit = React.createClass
  displayName: 'ReactGroupMembershipEdit'
  mixins: [UpdateOnSignInOrOutMixin, React.BackboneMixin('user')]


  render: ->
    return _span([], 'Please sign in.') unless currentSession.signedIn()

    _span [],
      if @props.user.get('admin')
        ReactAdminGroupEdit user: @props.user
      else
        "Natch!"
        


window.ReactAdminGroupEdit = React.createClass
  displayName: 'ReactAdminGroupEdit'
  mixins: [React.BackboneMixin('user')]

  render: ->
    _span [], JSON.stringify(@props.user.toJSON(),null,true)
