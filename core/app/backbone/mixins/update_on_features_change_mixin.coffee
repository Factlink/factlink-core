window.UpdateOnFeaturesChangeMixin =
  componentDidMount: ->
    window.currentUser.on 'change:features', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.currentUser.off null, null, @
