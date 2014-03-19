window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    second_button =
      _span ["delete-button-second-container-outer"],
        _span ["delete-button-second-container-inner"],
          _span ["delete-button-second button-small button-danger", onClick: @props.onDelete],
            @props.text || 'Delete'

    first_button =
      _a ["delete-button-first", onClick: @_toggleButton],
        _i ["icon-trash"]

    _span [
      'delete-button'
      'delete-button-open' if @state.opened
    ],
      second_button
      first_button
