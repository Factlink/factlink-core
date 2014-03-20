window.ReactUserTabs = React.createBackboneClass
  render: ->
    spaced_middle_dot = " \u00b7 "

    _div ['main-region-tabs'],
      _a [
        'active' if @props.page == 'about'
        rel: 'backbone'
        href: "/#{@model().get('username')}"
      ],
        'About'
      spaced_middle_dot
      _a [
        href: "/#{@model().get('username')}/edit"
      ],
        'Edit'
      spaced_middle_dot
      _a [
        href: "/#{@model().get('username')}/password/edit"
      ],
        'Change password'
      spaced_middle_dot
      _a [
        'active' if @props.page == 'notification-settings'
        rel: 'backbone'
        href: "/#{@model().get('username')}/notification-settings"
      ],
        'Notification Settings'
