ReactShareButton = React.createBackboneClass
  displayName: 'ReactShareButton'

  getInitialState: ->
    hovered: false

  render: ->
    _label ['pull-right share-button-container'
      onMouseEnter: => @setState(hovered: true)
      onMouseLeave: => @setState(hovered: false)
    ],
      if @model().serviceConnected @props.provider_name
        [
          _input [type: 'checkbox', checked: @props.checked,
            onChange: (event) => @props.onChange? event.target.checked]
          _span ["share-button share-button-#{@props.provider_name}"]
          if @state.hovered
            ReactPopover {},
              _div [],
                "Share to #{@props.provider_name.capitalize()}"
        ]
      else
        _a ["share-button share-button-#{@props.provider_name} js-accounts-popup-link",
          href: "/auth/#{@props.provider_name}?use_authorize=true&x_auth_access_type=write"
        ],
          if @state.hovered
            ReactPopover {},
              _div [],
                "Connect with #{@props.provider_name.capitalize()}"


window.ReactShareFactSelection = React.createBackboneClass
  displayName: 'ReactShareFactSelection'

  componentDidMount: ->
    currentUser.on 'change:services', @forceUpdate, @

  componentWillUnmount: ->
    currentUser.off 'change:services', @forceUpdate, @

  _connectedButton: ->
    _label ['pull-right share-button-container'],
      _input [type: 'checkbox'],
      _span ['share-button share-button-facebook']

  render: ->
    _div ['share-fact-selection'],
      ReactShareButton
        provider_name: 'facebook'
        model: currentUser
        checked: @props.providers.facebook
        onChange: (checked) => @props.onChange?('facebook', checked)
      ReactShareButton
        provider_name: 'twitter'
        model: currentUser
        checked: @props.providers.twitter
        onChange: (checked) => @props.onChange?('twitter', checked)
