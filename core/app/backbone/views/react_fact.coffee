window.ReactFact = React.createBackboneClass
  render: ->
    fact_url_host = @model().factUrlHost()
    _div ['feed-activity-annotation'],
      _span ["annotation-site"],
        _a ['annotation-site-avatar', href: @model().get('proxy_open_url'), target: '_blank'],
          _img ['proxy-link-favicon', src: "https://www.google.com/s2/u/0/favicons?domain=#{fact_url_host}"],

      _span ["annotation-body"],
        _a ['annotation-body-content', href: @model().get('proxy_open_url'), target: '_blank'],
          @model().get('displaystring')
