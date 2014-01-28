ready = $.Deferred()
complete = $.Deferred()

if /^(interactive|complete)$/.test(document.readyState)
  ready.resolve()
else
  document.addEventListener('DOMContentLoaded', -> ready.resolve())

if 'complete' == document.readyState
  complete.resolve()
else
  window.addEventListener('load', -> complete.resolve())

FactlinkJailRoot.ready_promise = ready.promise()
FactlinkJailRoot.load_promise = complete.promise()

