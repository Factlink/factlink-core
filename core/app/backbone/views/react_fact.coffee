ReactFactBody = React.createBackboneClass
  render: ->
    _a ["fact-body",
        href: @model().get('proxy_open_url'),
        target: '_blank'],
      @model().get('displaystring')

ReactProxyLink = React.createBackboneClass
  render: ->
    fact_url_host = @model().factUrlHost()

    _div ['proxy-link-container'],
      _a ["proxy-link",
          href: @model().get("proxy_open_url"),
          target:"_blank"],
        _img ["proxy-link-favicon",
              src:"https://www.google.com/s2/u/0/favicons?domain=#{fact_url_host}"],
          @model().factUrlTitle()
      _i ["proxy-link-overflow"]

window.ReactFact = React.createBackboneClass
  render: ->
    _div ['fact-view'],
      ReactFactBody(model: @model())
      ReactProxyLink(model: @model())
