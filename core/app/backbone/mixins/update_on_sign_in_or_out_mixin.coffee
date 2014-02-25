window.UpdateOnSignInOrOutMixin =
  componentDidMount: ->
    window.currentUser.on 'change:username', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.currentUser.off null, null, @
