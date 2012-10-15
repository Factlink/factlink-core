window.mp_track = (action, options) ->
  try
    if window.mixpanel
      mixpanel.track(action, options)
  catch error
    console.error "MixPanel error", error