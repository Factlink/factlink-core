window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    delete_button =
      _span ["delete-button button-small button-danger button-arrow-right", onClick: @props.onDelete],
        @props.text || 'Delete'

    ReactSlidingButton {slidingChildren: delete_button, opened: @state.opened},
      _a [onClick: @_toggleButton],
        _i ["icon-trash"]
