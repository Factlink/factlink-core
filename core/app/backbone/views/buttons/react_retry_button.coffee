window.ReactRetryButton = React.createClass
  displayName: 'ReactRetryButton'

  render: ->
    _a ['button-danger', onClick: @props.onClick, style: {float: 'right'} ],
      'Save failed - Retry'
