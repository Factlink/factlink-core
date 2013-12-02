msgPrefix = 'FL$msg*)k`dC:'
window.Factlink || window.Factlink = {}

Factlink.createFrameProxy = (target_window) -> (method_name) -> (args...) ->
  message = msgPrefix + JSON.stringify([method_name, args])
  target_window.postMessage message, '*'

Factlink.createFrameProxyObject = (target_window, methods) ->
  remoteProxy = Factlink.createFrameProxy target_window
  methods.reduce ((o, name) -> o[name] = remoteProxy name; o), {}

startsWith = (haystack, needle) -> haystack.lastIndexOf(needle, 0) == 0

Factlink.listenToWindowMessages = (source_window, receiver) ->
  handler = (e) ->
    if e.source == (source_window||e.source) && typeof e.data == 'string' && startsWith(e.data, msgPrefix)
      data_obj = JSON.parse(e.data.substring(msgPrefix.length))
      receiver[data_obj[0]].apply receiver, data_obj[1]
    return
  window.addEventListener 'message', handler

