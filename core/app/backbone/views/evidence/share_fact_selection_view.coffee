ReactShareButton = React.createBackboneClass
  displayName: 'ReactShareButton'

  getInitialState: ->
    hovered: false
    checked: false

  checked: -> @state.checked

  render: ->
    _label ['pull-right share-button-container'
      onMouseEnter: => @setState(hovered: true)
      onMouseLeave: => @setState(hovered: false)
    ],
      if @model().serviceConnected @props.provider_name
        [
          _input [type: 'checkbox', checked: @state.checked,
            onChange: (event) => @setState checked: event.target.checked]
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

  getInitialState: ->
    submitting: false

  componentDidMount: ->
    currentUser.on 'change:services', @forceUpdate, @

  componentWillUnmount: ->
    currentUser.off 'change:services', @forceUpdate, @

  _connectedButton: ->
    _label ['pull-right share-button-container'],
      _input [type: 'checkbox'],
      _span ['share-button share-button-facebook']

  render: ->
    if @state.submitting
      _div ['share-fact-selection'],
        _div ['share-fact-selection-loading-indicator'],
          ReactLoadingIndicator()
    else
      _div ['share-fact-selection'],
        ReactShareButton provider_name: 'facebook', ref: 'facebook', model: currentUser
        ReactShareButton provider_name: 'twitter', ref: 'twitter', model: currentUser

  submit: (message) ->
    provider_names = @_selectedProviderNames()
    return if provider_names.length == 0

    @setState submitting: true
    @model().share provider_names, message,
      complete: => @setState submitting: false
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing"

  _selectedProviderNames: ->
    names = []
    names.push 'twitter' if @refs.twitter.checked()
    names.push 'facebook' if @refs.facebook.checked()
    names
