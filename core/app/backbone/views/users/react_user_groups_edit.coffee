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

  getInitialState: ->
    @_freshState()

  _freshState: ->
    group: new Group

  _submit: ->
    alert('TODO: ' + JSON.stringify(@state.group.toJSON()))
    @setState @_freshState()

  render: ->
    console.log 'rendering', @state.group.cid
    _span [],
      ReactSubmittableForm {
          onSubmit: @_submit
          model: @state.group
          label: '(admin!) Add Group'
        },
          ReactInput
            model: @state.group
            label: 'Group name'
            attribute: 'groupname'
