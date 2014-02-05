FactlinkJailRoot.delay = (delay_timeout_milliseconds) ->
  deferred = $.Deferred()
  setTimeout( (-> deferred.resolve()), delay_timeout_milliseconds)
  deferred.promise()
