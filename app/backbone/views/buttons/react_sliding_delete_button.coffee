window.ReactSlidingDeleteButton = React.createBackboneClass
  displayName: 'ReactSlidingDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    label = _i ["icon-trash spec-delete-button-open"]

    ReactSlidingButton {label: label, opened: @state.opened},
      _button ["sliding-delete-inner-button button-small", onClick: @props.onDelete],
        'Delete'
