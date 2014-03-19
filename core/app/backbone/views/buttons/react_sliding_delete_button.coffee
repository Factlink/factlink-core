window.ReactSlidingDeleteButton = React.createBackboneClass
  displayName: 'ReactSlidingDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    label = _i ["icon-trash"]

    ReactSlidingButton {label: label, opened: @state.opened},
      _span ["sliding-delete-inner-button button-small button-danger button-arrow-right", onClick: @props.onDelete],
        'Delete'

