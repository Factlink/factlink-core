window.mp_track = (action, options) ->
  try
    mpmetrics.track(action, options)
  catch error
    console.error "MixPanel error", error