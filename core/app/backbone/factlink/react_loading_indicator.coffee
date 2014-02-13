window.ReactLoadingIndicator = React.createBackboneClass
  displayName: 'ReactLoadingIndicator'
  changeOptions: 'sync request'

  render: ->
    if @model().loading()
      _img ['ajax-loader', src: Factlink.Global.ajax_loader_image]
    else
      _span()
