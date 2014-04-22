window.ReactTopbarMenu = React.createClass
  displayName: 'ReactTopbarMenu'
  mixins: [UpdateOnSignInOrOutMixin]

  _adminItems: ->
    _span [],
      _li ['dropdown-menu-item'],
        _a [href: '/a/users'],
          'Users'
      _li ['dropdown-menu-item'],
        _a [href: '/a/clean'],
          'Clean actions'
      _li ['dropdown-menu-item'],
        _a [href: '/a/global_feature_toggles'],
          'Global features'
      _li ['dropdown-menu-item'],
        _a [href: '/a/info'],
          'Info'
      _li ['dropdown-menu-item'],
        _a [href: '/a/cause_error'],
          'Cause Error'
      _li ['dropdown-menu-item'],
        _a [href: '/a/resque'],
          'Resque'

  render: ->
    @transferPropsTo _li ['dropdown'],
      _a ['dropdown-toggle', @props.linkClass, 'data-toggle': 'dropdown', href: 'javascript:'],
        _b ['caret']
      _ul ['dropdown-menu'],
        if !window.is_kennisland
          _li ['dropdown-menu-item'],
           _a [href: '/in-your-browser'],
             _i ['icon-globe']
             " In your browser"
          _li ['dropdown-menu-item'],
           _a [href: '/on-your-site'],
             _i ['icon-bookmark']
             " On your site"
        _li ['dropdown-menu-item'],
         _a [href: "/#{currentSession.user().get('username')}/edit", rel: 'backbone'],
           _i ['icon-cog']
           " Settings"
        _li ['dropdown-menu-item'],
         _a ['js-accounts-popup-link', href: "/users/out"],
           _i ['icon-off']
           " Sign out"

        if currentSession.user().get('admin')
          @_adminItems()

window.ReactTopbarSearch = React.createBackboneClass
  displayName: 'ReactTopbarSearch'

  _onSubmit: (e) ->
    e.preventDefault()
    url = '/search?s=' + encodeURIComponent @model().get('query')
    Backbone.history.navigate url, true

  _onFocus: ->
    mp_track "Search: Top bar search focussed"

  _onChange: (e) ->
    @model().set query: e.target.value

  render: ->
    _div ['topbar-search'],
      _form [onSubmit: @_onSubmit],
        _input ['topbar-search-field', id: 'spec-search', onFocus: @_onFocus,
                onChange: @_onChange, value: @model().get('query')]

window.ReactTopbar = React.createClass
  displayName: 'ReactTopbar'
  mixins: [UpdateOnSignInOrOutMixin]

  render: ->
    _div ['topbar'],
      if currentSession.signedIn()
        _div ['topbar-inner'],
          _ul ['topbar-menu'],
            _li ['topbar-menu-item'],
              _a ['topbar-menu-link', href: '/feed', rel: 'backbone'],
                'Feed'
            _li ['topbar-divider']
            _li ['topbar-menu-item'],
              _a ['topbar-menu-link', href: "/#{currentSession.user().get('username')}", rel: 'backbone'],
                _img ['topbar-profile-image image-30px', src: currentSession.user().avatar_url(30)]
                currentSession.user().get('name')
            _li ['topbar-divider']
            ReactTopbarMenu className: 'topbar-menu-item', linkClass: 'topbar-menu-link'

          _a ['topbar-logo', href: '/feed', rel: 'backbone']

          ReactTopbarSearch model: Factlink.topbarSearchModel
      else
        _div ['topbar-inner'],
          _ul ['topbar-menu'],
            if !window.is_kennisland
              _li ['topbar-menu-item topbar-in-your-browser'],
                _a ['topbar-menu-link', href: '/in-your-browser'],
                  "In your browser"
              _li ['topbar-divider topbar-in-your-browser']
              _li ['topbar-menu-item topbar-on-your-site'],
                _a ['topbar-menu-link', href: '/on-your-site'],
                  "On your site"
            _li ['topbar-divider topbar-on-your-site']
            _li ['topbar-menu-item'],
              _div ['topbar-connect'],
                ReactSigninLinks()

          _a ['topbar-logo', href: '/']
