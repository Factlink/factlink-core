window.ReactLoadingIndicator = React.createBackboneClass
  displayName: 'ReactLoadingIndicator'
  changeOptions: 'sync request'

  render: ->
    if !@model() || @model().loading()
      _img ['ajax-loader', src: Factlink.Global.ajax_loader_image]
    else if @model().length > 0
      _span()
    else
      @props.children || _span()
