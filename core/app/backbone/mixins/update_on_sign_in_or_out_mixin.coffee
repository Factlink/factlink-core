window.UpdateOnSignInOrOutMixin =
  componentDidMount: ->
    window.currentSession.user().on 'change:username', ( ->
      if @isMounted()
        @forceUpdate()
    ), @

  componentWillUnmount: ->
    window.currentSession.user().off null, null, @
