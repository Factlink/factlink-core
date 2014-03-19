window.ReactSlidingDeleteButton = React.createBackboneClass
  displayName: 'ReactSlidingDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    delete_inner_button =
      _span ["sliding-delete-inner-button button-small button-danger button-arrow-right", onClick: @props.onDelete],
        'Delete'

    ReactSlidingButton {slidingChildren: delete_inner_button, opened: @state.opened},
      _a [onClick: @_toggleButton],
        _i ["icon-trash"]
