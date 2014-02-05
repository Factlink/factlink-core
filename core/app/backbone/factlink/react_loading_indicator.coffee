window.ReactLoadingIndicator = React.createClass
  displayName: 'ReactLoadingIndicator'

  render: ->
    R.img
      className: 'ajax-loader'
      src: Factlink.Global.ajax_loader_image
