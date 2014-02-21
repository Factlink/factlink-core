ReactFactBody = React.createBackboneClass
  render: ->
    fact_url_host = @model().factUrlHost()
    _a ["annotation-favicon", href: @model().get('proxy_open_url'), target: '_blank'],
    _img ["proxy-link-favicon", src:"https://www.google.com/s2/u/0/favicons?domain=#{fact_url_host}"],

    _a ["annotation-body",
        href: @model().get('proxy_open_url'),
        target: '_blank'],
      @model().get('displaystring')


window.ReactFact = React.createBackboneClass
  render: ->
    _div ['feed-activity-annotation'],
      ReactFactBody(model: @model())

