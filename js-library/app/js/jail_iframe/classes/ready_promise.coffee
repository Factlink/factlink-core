ready = $.Deferred()
complete = $.Deferred()

if /^(interactive|complete)$/.test(document.readyState)
  ready.resolve()
else
  document.addEventListener('DOMContentLoaded', -> ready.resolve())

if 'complete' == document.readyState
  complete.resolve()
else
  console.log "queuing handler since we're in state #{document.readyState}"
  window.addEventListener('load', -> complete.resolve())

console.log document.readyState

FactlinkJailRoot.ready_promise = ready.promise()
FactlinkJailRoot.load_promise = complete.promise()

FactlinkJailRoot.ready_promise.done -> console.log 'AAAAAAAAAAAAAAAA'
FactlinkJailRoot.load_promise.done -> console.log 'BBBBBBBBBBBBBBBB'


FactlinkJailRoot.ready_promise
  .then( -> FactlinkJailRoot.delay 4000)
  .then( -> console.log("final state #{document.readyState}"))
