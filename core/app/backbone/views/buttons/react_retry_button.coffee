window.ReactRetryButton = React.createClass
  displayName: 'ReactRetryButton'

  render: ->
    _a [
      'button-danger'
      onClick: => @refs.signinPopover.submit(=> @props.onClick?())
      style: {float: 'right'}
    ],
      'Save failed - Retry'
      ReactSigninPopover
        ref: 'signinPopover'
