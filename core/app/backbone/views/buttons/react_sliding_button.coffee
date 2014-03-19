window.ReactSlidingButton = React.createClass
  displayName: 'ReactSlidingButton'

  render: ->
    _span [
      'sliding-button'
      'sliding-button-open' if @props.opened
    ],
      _span ["sliding-button-container-outer"],
        _span ["sliding-button-container-inner"],
          @props.slidingChildren
      @props.children
