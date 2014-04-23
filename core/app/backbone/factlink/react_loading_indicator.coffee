window.ReactLoadingIndicator = React.createBackboneClass
  displayName: 'ReactLoadingIndicator'
  changeOptions: 'sync request'

  render: ->
    if !@model() || @model().loading()
      _img ['ajax-loader', src: Factlink.Global.ajax_loader_image]
    else
      _span ['spec-loading-indicator-done']
