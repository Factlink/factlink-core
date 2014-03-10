window.UpdateOnFeaturesChangeMixin =
  componentDidMount: ->
    window.currentUser.on 'change:features', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.currentUser.off null, null, @

  canHaz: (feature) ->
    feature in currentUser.get('features')
