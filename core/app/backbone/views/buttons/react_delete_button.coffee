window.ReactDeleteButton = React.createBackboneClass
  getInitialState: ->
    opened: false

  toggleButton: -> @setState opened: !@state.opened

  slideButtonIn: -> @setState opened: false

  onDelete: -> @props.onDelete()

  render: ->
    second_button =
      R.span className: "delete-button-second-container",
        R.span className: "delete-button-second button button-small button-danger", onClick: @onDelete,
          'Delete'
        R.span className: "delete-button-arrow"

    first_button =
      R.span className: "delete-button-first", onClick: @toggleButton,
        R.i className: "icon-trash"

    around_element_klass = [
      'delete-button'
      'delete-button-open' if @state.opened
    ].join(' ')

    R.span className: around_element_klass, onMouseLeave: @slideButtonIn,
      second_button
      first_button
