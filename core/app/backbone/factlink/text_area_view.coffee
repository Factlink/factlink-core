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

  updateText: (text) ->
    @setState text: text
    @props.onChange?(text)

  focusInput: ->
    @refs.textarea.getDOMNode().focus()

  $_textarea: ->
    $(@getDOMNode())

  insert: (text) ->
    cursorPos =  @$_textarea().prop('selectionStart')
    @setState text: insertTextInto(@state.text, cursorPos, text), =>
      @focusInput()

  _handleSubmit: (e)->
    if e.keyCode == 13 && (e.ctrlKey || e.metaKey || e.shiftKey)
      e.preventDefault()
      e.stopPropagation()
      @props.onSubmit()

  componentDidMount: ->
    @$_textarea().autosize append: '\n\n'

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
      value: @state.text
