DEFAULT_SYNC_DELAY = 0

getValue = (object, prop) ->
  return null if (!(object && object[prop]))

  if _.isFunction(object[prop])
    object[prop]()
  else
    object[prop]

wrap_success_and_error = (options) ->
  sync_delay = get_sync_delay()

  return if sync_delay < 1

  console.warn "Delaying Backbone.sync with #{sync_delay} milliseconds"

  old_success = options.success
  old_error = options.error

  options.success = (args...) -> _.delay old_success, sync_delay, args...
  options.error = (args...) -> _.delay old_error, sync_delay, args...

get_sync_delay = ->
  sync_delay = getSetting("sync_delay")

  if not sync_delay
    0
  else if parseInt(sync_delay, 10) > 0
    parseInt(sync_delay, 10)
  else if sync_delay == "random"
    Math.random() * 1000
  else
    DEFAULT_SYNC_DELAY

old_sync = Backbone.sync
new_sync = (method, model, options) ->
  if (!options.url)
    url = getValue(model, 'url') || urlError();
  else
    url = options.url

  unless url.match /\.json($|\?)/
    url = url + '.json'

  wrap_success_and_error(options)

  old_sync(method, model, _.extend({},options, {url: url}))

Backbone.sync = new_sync
