ReactActionButton = React.createClass
  displayName: 'ReactActionButton'

  getInitialState: ->
    hovered: false

  _events: ->
    onMouseEnter: => @setState hovered: true
    onMouseLeave: => @setState hovered: false
    onClick: =>
      return if @props.loading

      @props.onClick()
      @setState hovered: false

  render: ->
    if @props.loading
      _button [@_events(), @props.className, 'button loading-indicator-container'],
        _img ['loading-indicator-image', src: Factlink.Global.ajax_loader_image]
        _span ['loading-indicator-label'],
          "Loading..."
    else
      if @props.checked
        if @state.hovered
          _button [@_events(), @props.className, 'button-danger'],
            _span ['icon-remove']
            @props.checked_hovered_label
        else
          _button [@_events(), @props.className, 'button button-action-checked'],
            _span ['icon-ok']
            @props.checked_unhovered_label
      else
        if @state.hovered
          _button [@_events(), @props.className, 'button-confirm'],
            @props.unchecked_label
        else
          _button [@_events(), @props.className, 'button'],
            @props.unchecked_label

window.ReactFollowUserButton = React.createClass
  displayName: 'ReactFollowUserButton'

  componentDidMount: ->
    currentSession.user().following.on 'add remove reset sync reset', (-> @forceUpdate()), @
    currentSession.user().following.fetch()

  componentWillUnmount: ->
    currentSession.user().following.off null, null, @

  render: ->
    ReactActionButton
      className: 'user-follow-user-button'
      unchecked_label:         Factlink.Global.t.follow_user.capitalize()
      checked_hovered_label:   Factlink.Global.t.unfollow.capitalize()
      checked_unhovered_label: Factlink.Global.t.following.capitalize()
      loading: currentSession.user().following.loading()
      checked: @props.user.followed_by_me()
      onClick: @_toggleFollowing

  _toggleFollowing: ->
    if @props.user.followed_by_me()
      @props.user.unfollow()
    else
      @props.user.follow()
