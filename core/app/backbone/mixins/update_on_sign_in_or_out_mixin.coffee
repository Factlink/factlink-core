window.UpdateOnSignInOrOutMixin =
  componentDidMount: ->
    window.session.user().on 'change:username', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.session.user().off null, null, @
