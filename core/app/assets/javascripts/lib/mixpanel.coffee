window.mp_track = (action, options) ->
  try
    mixpanel.track(action, options)
  catch error
    console.error "MixPanel error", error