#= require jquery-autosize

#we're using jquery autosize rather than jquery elastic since this works
#even if initialized before the element is in the DOM.

Backbone.Factlink ||= {}

insertTextInto = (currentText, cursorPos, text) ->
  textBefore = currentText.substring(0, cursorPos)
  textAfter = currentText.substring(cursorPos, currentText.length)

  if /\S$/.test(textBefore)
    text = ' ' + text
  if /^\S/.test(textAfter)
    text += ' '
  textBefore + text + textAfter

React.defineClass('ReactTextArea')
  getInitialState: ->
    text: @props.defaultValue

  _onChange: (e)->
    @updateText e.target.value

  updateText: (text, callback) ->
    @setState text: text, callback
    @props.onChange?(text)

  focusInput: ->
    @refs.textarea.getDOMNode().focus()

  $_textarea: ->
    $(@getDOMNode())

  insert: (text) ->
    cursorPos =  @$_textarea().prop('selectionStart')
    @updateText insertTextInto(@state.text, cursorPos, text), =>
      @focusInput()

  _handleSubmit: (e)->
    if e.keyCode == 13 && (e.ctrlKey || e.metaKey || e.shiftKey)
      e.preventDefault()
      e.stopPropagation()
      @props.onSubmit()

  _onFocus: ->
    unless @_autosized
      @_autosized = true
      @$_textarea().autosize append: '\n\n'
    @props.onFocus?()

  componentDidUpdate: ->
    @$_textarea().trigger('autosize.resize')

  componentWillUnmount: ->
    @$_textarea().trigger('autosize.destroy')

  render: ->
    _textarea
      className: "text_area_view",
      placeholder: @props.placeholder
      ref: 'textarea'
      onChange: @_onChange
      onKeyDown: @_handleSubmit
      onFocus: @_onFocus
      value: @state.text
