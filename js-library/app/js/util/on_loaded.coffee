console.info 'onLoaded'

_loaded =
  'intermediateFrameReady': false
  'factlink.factsLoaded': false

getLoadedCallback = (event_name) ->
  return -> _loaded[event_name] = true

for event_name, value of _loaded
  # Call a method to copy event_name, as it changes
  Factlink.on event_name, getLoadedCallback(event_name)

Factlink.onLoaded = (event_name, callback) ->
  if _loaded[event_name]
    callback()
  else
    Factlink.on event_name, ->
      callback()
