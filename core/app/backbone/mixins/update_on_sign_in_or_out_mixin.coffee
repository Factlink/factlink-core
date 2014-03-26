window.UpdateOnSignInOrOutMixin =
  componentDidMount: ->
    window.currentSession.user().on 'change:username', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.currentSession.user().off null, null, @
