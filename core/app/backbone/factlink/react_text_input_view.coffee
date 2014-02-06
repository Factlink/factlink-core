Backbone.Factlink ||= {}
Backbone.Factlink.ReactTextInputView = React.createBackboneClass

  getInitialState: ->
    text: @props.defaultValue

  focusInput: ->
    @refs.input.getDOMNode().focus()

  _parseKeyDown: (e) ->
    eventHandled = true

    switch e.keyCode
      when 13 then @props.onReturn?()
      when 40 then @props.onDown?()
      when 38 then @props.onUp?()
      when 27 then @props.onEscape?()
      else eventHandled = false

    if eventHandled
      e.preventDefault()
      e.stopPropagation()

  _onChange: (e) ->
    @setState text: e.target.value
    @props.onChange?(e.target.value)

  render: ->
    _input
      className: 'typeahead'
      autoComplete: 'off'
      type: 'text'
      value: @state.text
      placeholder: @props.placeholder
      onKeyDown: @_parseKeyDown
      onChange: @_onChange
      ref: 'input'
