window.ReactSlidingButton = React.createClass
  displayName: 'ReactSlidingButton'

  getInitialState: ->
    opened: !!@props.initialOpened

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    _span [
      'sliding-button'
      'sliding-button-open' if @state.opened
      'sliding-button-right' if @props.right
    ],
      _a [onClick: @_toggleButton],
        @props.label
      _span ["sliding-button-container-outer"],
        _span ["sliding-button-container-inner"],
          @props.children
