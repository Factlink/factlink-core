window.ReactAddToGroupCheckboxes = React.createClass
  displayName: "ReactAddToGroupCheckboxes"
  mixins: [
    React.BackboneMixin('groups')
    React.BackboneMixin('user')
  ]

  render: ->
    _div [],
      _h4 null, "Groups:"
      @props.groups.map (group) =>
        ReactAddToGroupCheckbox
          group: group
          users_groups: @props.user.groups()
          key: group.id
