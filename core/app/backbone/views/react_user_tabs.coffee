window.ReactUserTabs = React.createBackboneClass
  render: ->
    return _span() unless FactlinkApp.isCurrentUser @model()

    spaced_middle_dot = " \u00b7 "

    _div ['main-region-tabs'],
      _a [
        'main-region-tab-active' if @props.page == 'about'
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
        'main-region-tab-active' if @props.page == 'change_password'
        rel: 'backbone'
        href: "/#{@model().get('username')}/change-password"
      ],
        'Change password'
      spaced_middle_dot
      _a [
        'main-region-tab-active' if @props.page == 'notification-settings'
        rel: 'backbone'
        href: "/#{@model().get('username')}/notification-settings"
      ],
        'Notification Settings'
