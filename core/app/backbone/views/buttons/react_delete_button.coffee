window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    second_button =
      _span ["delete-button-second-container"],
        _span ["delete-button-second button-small button-danger", onClick: @props.onDelete],
          @props.text || 'Delete'
        _span ["delete-button-arrow"]

    first_button =
      _a ["delete-button-first", onClick: @_toggleButton],
        _i ["icon-trash"]

    _span [
      'delete-button'
      'delete-button-open' if @state.opened
    ],
      second_button
      first_button
