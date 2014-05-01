window.ReactAddToGroupCheckbox = React.createClass
  displayName: "ReactAddToGroupCheckbox"
  mixins: [
    React.BackboneMixin('group')
    React.BackboneMixin('users_groups')
  ]

  _addToGroup: ->
    group = @props.users_groups.create @props.group.attributes,
      error: =>
       @props.users_groups.remove group
       Factlink.notificationCenter.error 'User could not be added to group, please try again.'

  render: ->
    in_group = @props.users_groups.some((group) => group.id == @props.group.id)
    _label [],
      if in_group
        _input [type: "checkbox", checked: true, disabled: true]
      else
        _input [type: "checkbox", checked: false, onChange: @_addToGroup]
      @props.group.get('groupname')
