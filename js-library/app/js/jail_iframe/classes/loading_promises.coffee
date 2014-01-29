if /^(interactive|complete)$/.test(document.readyState)
  FactlinkJailRoot.host_ready_promise.resolve()
else
  document.addEventListener('DOMContentLoaded', -> FactlinkJailRoot.host_ready_promise.resolve())

if 'complete' == document.readyState
  FactlinkJailRoot.host_loaded_promise.resolve()
else
  window.addEventListener('load', -> FactlinkJailRoot.host_loaded_promise.resolve())

