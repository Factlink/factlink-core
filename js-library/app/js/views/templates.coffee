requesting = {}

Factlink.templates = {}

Factlink.templates.getTemplate = (str, callback = ->) ->
  if Factlink.tmpl[str]?
    callback Factlink.tmpl[str]
  else
    Factlink.el.bind "factlink.tmpl.#{str}", ->
      callback Factlink.tmpl[str]

    fetchTemplate str, callback unless requesting[str]

Factlink.templates.preload = ->
  Factlink.templates.getTemplate 'indicator'
  Factlink.templates.getTemplate 'create', (template) ->
    Factlink.prepare = new Factlink.Prepare(template)

fetchTemplate = (str, callback) ->
  requesting[str] = true

  $.ajax
    url: "#{FactlinkConfig.api}/templates/#{str}"
    dataType: 'jsonp'
    crossDomain: true
    type: 'GET'
    jsonp: 'callback'
    success: (data) ->
      Factlink.tmpl[str] = _.template(data)
      Factlink.el.trigger "factlink.tmpl.#{str}"
