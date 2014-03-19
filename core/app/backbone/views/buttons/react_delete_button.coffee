window.ReactDeleteButton = React.createBackboneClass
  displayName: 'ReactDeleteButton'

  getInitialState: ->
    opened: false

  _toggleButton: -> @setState opened: !@state.opened

  render: ->
    second_button =
      R.span className: "delete-button-second-container",
        R.span className: "delete-button-second button-small button-danger", onClick: @props.onDelete,
          @props.text || 'Delete'
        R.span className: "delete-button-arrow"

    first_button =
      R.span className: "delete-button-first", onClick: @_toggleButton,
        R.i className: "icon-trash"

    around_element_klass = [
      'delete-button'
      'delete-button-open' if @state.opened
    ].join(' ')

    R.span className: around_element_klass,
      second_button
      first_button
