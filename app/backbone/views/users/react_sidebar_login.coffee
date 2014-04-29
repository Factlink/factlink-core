window.ReactSidebarLogin = React.createBackboneClass
  displayName: 'ReactSidebarLogin'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    if !currentSession.signedIn()
      _div ['discussion-login'],
        ReactSigninLinks buttonClassName: 'button-connect-small'
    else
      _ul ['discussion-menu'],
        _li ['discussion-menu-item'],
          _a [href: "/user/#{currentSession.user().get('username')}", rel: 'backbone'],
            _img ['image-30px topbar-profile-image', src: currentSession.user().avatar_url(30)],
            _span ['discussion-menu-username'],
              currentSession.user().get('name')

        ReactTopbarMenu className: 'discussion-menu-item', linkClass: 'discussion-menu-link'
