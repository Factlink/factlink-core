requesting = {}

Factlink.templates = {}

Factlink.templates.getTemplate = (str, callback = ->) ->
  if Factlink.tmpl[str]?
    callback Factlink.tmpl[str]
  else
    Factlink.el.bind "factlink.tmpl.#{str}", ->
      callback Factlink.tmpl[str]

    if not requesting[str]
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

Factlink.templates.preload = ->
  Factlink.templates.getTemplate 'indicator'
  Factlink.templates.getTemplate 'create', (template) ->
    Factlink.prepare = new Factlink.Prepare template
