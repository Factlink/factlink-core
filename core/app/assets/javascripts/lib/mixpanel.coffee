window.mp_track = (action, options) ->
  try
    if window.mixpanel
      if FactlinkApp.started && FactlinkApp.signedIn()
        mixpanel.name_tag currentUser.get('username')
        mixpanel.identify currentUser.get('id')
      mixpanel.track(action, options)
  catch error
    console.error "MixPanel error", error
