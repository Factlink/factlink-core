getValue = (object, prop) ->
    return null if (!(object && object[prop]))

    if _.isFunction(object[prop])
      object[prop]()
    else
      object[prop]

old_sync = Backbone.sync
new_sync = (method, model, options) ->
  if (!options.url)
    url = getValue(model, 'url') || urlError();
  else
    url = options.url

  unless url.match /\.json($|\?)/
    url = url + '.json'

  old_sync(method, model, _.extend({},options, {url: url}))

Backbone.sync = new_sync