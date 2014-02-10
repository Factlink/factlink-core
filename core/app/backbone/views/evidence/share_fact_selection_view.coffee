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

  _socialButton: (provider_name) ->
    if currentUser.serviceConnected provider_name
      _label ['pull-right share-button-container'],
        _input [type: 'checkbox', checked: @state.twitterChecked,
                onChange: (event) => @setState twitterChecked: event.target.checked]
        _span ["share-button share-button-#{provider_name}"]
    else
      _a ["share-button share-button-#{provider_name} pull-right js-accounts-popup-link",
        href: "/auth/#{provider_name}?use_authorize=true&x_auth_access_type=write"]

  render: ->
    if @state.submitting
      _div ['share-fact-selection'],
        _div ['share-fact-selection-loading-indicator'],
          ReactLoadingIndicator()
    else
      _div ['share-fact-selection'],
        @_socialButton('facebook'),
        @_socialButton('twitter')

    # @trigger 'removeTooltips'

    # Backbone.Factlink.makeTooltipForView @,
    #   positioning:
    #     side: 'top'
    #     popover_className: 'translucent-popover'
    #   selector: '.js-connect-twitter'
    #   tooltipViewFactory: => new TextView text: 'Connect with Twitter'

    # Backbone.Factlink.makeTooltipForView @,
    #   positioning:
    #     side: 'top'
    #     popover_className: 'translucent-popover'
    #   selector: '.js-connect-facebook'
    #   tooltipViewFactory: => new TextView text: 'Connect with Facebook'

    # Backbone.Factlink.makeTooltipForView @,
    #   positioning:
    #     side: 'top'
    #     popover_className: 'translucent-popover'
    #   selector: '.js-share-twitter'
    #   tooltipViewFactory: => new TextView text: 'Share to Twitter'

    # Backbone.Factlink.makeTooltipForView @,
    #   positioning:
    #     side: 'top'
    #     popover_className: 'translucent-popover'
    #   selector: '.js-share-facebook'
    #   tooltipViewFactory: => new TextView text: 'Share to Facebook'


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
    names.push 'twitter' if @state.twitterChecked
    names.push 'facebook' if @state.facebookChecked
    names
