ReactSlidingButton = React.createClass
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


window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    first_button =
      _a ["delete-button-first", onClick: @_toggleButton],
        _i ["icon-trash"]

    second_button =
      _span ["delete-button-second button-small button-danger button-arrow-right", onClick: @props.onDelete],
        @props.text || 'Delete'

    ReactSlidingButton {slidingChildren: second_button, opened: @state.opened},
      first_button
