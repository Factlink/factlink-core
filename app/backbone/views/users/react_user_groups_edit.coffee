window.ReactGroupMembershipEdit = React.createClass
  displayName: 'ReactGroupMembershipEdit'
  mixins: [UpdateOnSignInOrOutMixin, React.BackboneMixin('user')]

  getInitialState: ->
    groups = new AllGroups
    groups.fetch()
    groups: groups

  render: ->
    return _span([], 'Please sign in.') unless currentSession.signedIn()

    _span [],
      if @props.user.get('admin')
        ReactAdminGroupEdit
          user: @props.user
          groups: @state.groups
      else
        "Placeholder for non-admin functionality that's to come."



window.ReactAdminGroupEdit = React.createClass
  displayName: 'ReactAdminGroupEdit'
  mixins: [React.BackboneMixin('user'), React.BackboneMixin('groups')]

  getInitialState: ->
    @_freshState()

  _freshState: ->
    group: new Group

  _submit: ->
    group = @state.group
    @props.groups.add group
    group.save members: [ @props.user.get('username') ],
      success: (o)=>
        Factlink.notificationCenter.success "Group #{o.get('groupname')} created."
      error: (o)=>
        Factlink.notificationCenter.error  "Group #{o.get('groupname')} could not be created!"

    @setState @_freshState()

  render: ->
    _div [],
      ReactSubmittableForm {
          onSubmit: @_submit
          model: @state.group
          label: '(admin!) Add Group'
        },
          ReactInput
            model: @state.group
            label: 'Group name'
            attribute: 'groupname'

