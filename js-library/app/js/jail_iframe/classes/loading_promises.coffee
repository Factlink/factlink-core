setTimeout ->
  isDOMContentLoaded =
    loaded: true
    interactive: !(document.documentMode < 11)
    complete: true


  if isDOMContentLoaded[document.readyState]
    FactlinkJailRoot.host_ready_promise.resolve()
  else
    document.addEventListener('DOMContentLoaded', -> FactlinkJailRoot.host_ready_promise.resolve())

  if 'complete' == document.readyState
    FactlinkJailRoot.host_loaded_promise.resolve()
  else
    window.addEventListener('load', ->
      FactlinkJailRoot.host_ready_promise.resolve()
      #IE pre 11's readyStates are weird; to ensure we can't miss anything,
      #trigger ready at the latest on load
      
      FactlinkJailRoot.host_loaded_promise.resolve()
    )
, 0
