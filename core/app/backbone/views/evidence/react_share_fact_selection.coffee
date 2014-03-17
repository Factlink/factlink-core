ReactShareButton = React.createBackboneClass
  displayName: 'ReactShareButton'

  getInitialState: ->
    hovered: false

  render: ->
    _span ['share-button-container'
      onMouseEnter: => @setState(hovered: true)
      onMouseLeave: => @setState(hovered: false)
    ],
      if @model().serviceConnected @props.provider_name
        [
          _label [key: 'share-label'],
            _input [type: 'checkbox', checked: @props.checked,
              onChange: (event) => @props.onChange? event.target.checked]
            _span ["share-button share-button-#{@props.provider_name}"]
          if @state.hovered
            ReactPopover {key: 'share_popover'},
              _div [],
                "Share to #{@props.provider_name.capitalize()}"
        ]
      else
        _a ["share-button share-button-#{@props.provider_name} js-accounts-popup-link",
          key: 'connect-button'
          href: "/auth/#{@props.provider_name}?use_authorize=true&x_auth_access_type=write"
        ],
          if @state.hovered
            ReactPopover {key: 'connect_popover'},
              _div [],
                "Connect with #{@props.provider_name.capitalize()}"


window.ReactShareFactSelection = React.createBackboneClass
  displayName: 'ReactShareFactSelection'

  componentDidMount: ->
    currentUser.on 'change:services', => @forceUpdate()

  componentWillUnmount: ->
    currentUser.off 'change:services'

  _connectedButton: ->
    _label ['share-button-container'],
      _input [type: 'checkbox'],
      _span ['share-button share-button-facebook']

  render: ->
    _div ['share-fact-selection'],
      ReactShareButton
        provider_name: 'facebook'
        key: 'facebook'
        model: currentUser
        checked: @props.providers.facebook
        onChange: (checked) => @props.onChange?('facebook', checked)
      ReactShareButton
        provider_name: 'twitter'
        key: 'twitter'
        model: currentUser
        checked: @props.providers.twitter
        onChange: (checked) => @props.onChange?('twitter', checked)
