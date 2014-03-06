window.ReactRetryButton = React.createClass
  displayName: 'ReactRetryButton'

  render: ->
    _button [
      'button-danger'
      onClick: => @refs.signinPopover.submit(=> @props.onClick?())
      style: {float: 'right'}
    ],
      'Save failed - Retry'
      ReactSigninPopover
        ref: 'signinPopover'
