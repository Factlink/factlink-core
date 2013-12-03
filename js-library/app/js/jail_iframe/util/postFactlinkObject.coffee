# Note: this file is duplicated between core and js-lib
# the implementations may differ slightly due to the differing release schedules

msgPrefix = 'FL$msg*)k`dC:'

window.FactlinkJailRoot || window.FactlinkJailRoot = {}

FactlinkJailRoot.createFrameProxy = (target_window) -> (method_name) -> (args...) ->
  message = msgPrefix + JSON.stringify([method_name, args])
  target_window.postMessage message, '*'

FactlinkJailRoot.createFrameProxyObject = (target_window, methods) ->
  remoteProxy = FactlinkJailRoot.createFrameProxy target_window
  methods.reduce ((o, name) -> o[name] = remoteProxy name; o), {}

startsWith = (haystack, needle) -> haystack.lastIndexOf(needle, 0) == 0

FactlinkJailRoot.listenToWindowMessages = (receiver) ->
  handler = (e) ->
    if typeof e.data == 'string' && startsWith(e.data, msgPrefix)
      data_obj = JSON.parse(e.data.substring(msgPrefix.length))
      receiver[data_obj[0]].apply receiver, data_obj[1]
    return
  window.addEventListener 'message', handler
