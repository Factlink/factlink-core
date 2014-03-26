window.UpdateOnFeaturesChangeMixin =
  componentDidMount: ->
    window.session.user().on 'change:features', (-> @forceUpdate()), @

  componentWillUnmount: ->
    window.session.user().off null, null, @

  canHaz: (feature) ->
    feature in (session.user().get('features') || [])
