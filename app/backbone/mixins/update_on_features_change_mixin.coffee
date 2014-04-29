window.UpdateOnFeaturesChangeMixin =
  componentDidMount: ->
    window.currentSession.user().on 'change:features', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.currentSession.user().off null, null, @

  canHaz: (feature) ->
    feature in (currentSession.user().get('features') || [])
