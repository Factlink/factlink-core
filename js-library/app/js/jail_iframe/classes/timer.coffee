FactlinkJailRoot.Timer = (delay) ->
  deferred = $.Deferred()
  setTimeout( (-> deferred.resolve()), delay)
  deferred.promise()
