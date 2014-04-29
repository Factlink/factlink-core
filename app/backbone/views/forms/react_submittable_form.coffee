window.ReactSubmittableForm = React.createBackboneClass
  displayName: 'ReactSubmittableForm'

  _onSubmit: (e) ->
    e.preventDefault()
    @props.onSubmit() if @model().isValid()

  render: ->
    _form [
      onSubmit: @_onSubmit
    ],
      @props.children
      _div ['controls'],
        _button [
          'button-confirm'
          'controls-information-item'
          disabled: 'disabled' unless @model().isValid()
          onClick: @_onSubmit
        ],
          @props.label
