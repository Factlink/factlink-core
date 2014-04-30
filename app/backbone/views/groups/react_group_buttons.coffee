window.ReactGroupButtons = React.createClass
  displayName: "ReactGroupButtons"
  mixins: [
    React.BackboneMixin('groups')
    React.BackboneMixin('user')
  ]

  render: ->
    _div [],
      _h4 null, "Groups:"
      @props.groups.map (group) =>
        ReactGroupButton
          group: group
          users_groups: @props.user.groups()
          key: group.id

