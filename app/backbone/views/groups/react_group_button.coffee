window.ReactGroupButton = React.createClass
  displayName: "ReactGroupButton"
  mixins: [
    React.BackboneMixin('group')
    React.BackboneMixin('users_groups')
  ]

  _addToGroup: ->
    debugger
    @props.users_groups.create @props.group.attributes,
      success: => console.info 'success'
      error: => console.info 'error'


  render: ->
    in_group = @props.users_groups.some((group) => group.id == @props.group.id)
    _label [],
      if in_group
        _input [type: "checkbox", checked: true, disabled: true]
      else
        _input [type: "checkbox", onChange: @_addToGroup]
      @props.group.get('groupname')



