window.ReactLoadingIndicator = React.createClass
  render: ->
    R.img
      className: 'ajax-loader'
      src: Factlink.Global.ajax_loader_image
