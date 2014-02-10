Backbone.Factlink ||= {}
Backbone.Factlink.ReactTextInputView = React.createBackboneClass

  getInitialState: ->
    text: ''

  focusInput: ->
    @refs.input.getDOMNode().focus()

  _parseKeyDown: (e) ->
    eventHandled = true

    switch e.keyCode
      when 13 then @props.onReturn?()
      when 40 then @props.onDown?()
      when 38 then @props.onUp?()
      when 27 then @_setText ''
      else eventHandled = false

    return !eventHandled

  _onChange: (e) -> @_setText e.target.value

  _setText: (text) ->
    @setState text: text
    @props.onChange?(text)

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
