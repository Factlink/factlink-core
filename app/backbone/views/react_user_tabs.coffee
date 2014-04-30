window.ReactUserTabs = React.createBackboneClass
  render: ->
    return _span() unless currentSession.isCurrentUser @model()

    spaced_middle_dot = " \u00b7 "

    _div ['main-region-tabs'],
      _a [
        'main-region-tab-active' if @props.page == 'about'
        rel: 'backbone'
        href: "/user/#{@model().get('username')}"
      ],
        'About'
      spaced_middle_dot
      _a [
        'main-region-tab-active' if @props.page == 'edit'
        rel: 'backbone'
        href: "/user/#{@model().get('username')}/edit"
      ],
        'Edit'
      spaced_middle_dot
      _a [
        'main-region-tab-active' if @props.page == 'change_password'
        rel: 'backbone'
        href: "/user/#{@model().get('username')}/change-password"
      ],
        'Change password'
      (if !window.is_kennisland
        spaced_middle_dot
        _a [
          'main-region-tab-active' if @props.page == 'notification-settings'
          rel: 'backbone'
          href: "/user/#{@model().get('username')}/notification-settings"
        ],
          'Notification Settings'
      else [])
