window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  _slideButtonIn: -> @setState opened: false

  _onDelete: -> @props.onDelete()

  render: ->
    second_button =
      R.span className: "delete-button-second-container",
        R.span className: "delete-button-second button button-small button-danger", onClick: @_onDelete,
          @props.text || 'Delete'
        R.span className: "delete-button-arrow"

    first_button =
      R.span className: "delete-button-first", onClick: @_toggleButton,
        R.i className: "icon-trash"

    around_element_klass = [
      'delete-button'
      'delete-button-open' if @state.opened
    ].join(' ')

    R.span className: around_element_klass, onMouseLeave: @_slideButtonIn,
      second_button
      first_button
