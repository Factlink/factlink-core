window.ReactFact = React.createBackboneClass
  displayName: 'ReactFact'
  render: ->
    fact_url_host = @model().factUrlHost()
    _div ['annotation'],
      _div ['annotation-avatar-container'],
        _img ['annotation-avatar', src: "https://www.google.com/s2/u/0/favicons?domain=#{fact_url_host}"]

      _div ["annotation-balloon"],
        _div ["annotation-host"],
          fact_url_host
        @model().get('displaystring')
