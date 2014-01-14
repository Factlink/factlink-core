#= require jquery.autosize

#we're using jquery autosize rather than jquery elastic since this works
#even if initialized before the element is in the DOM.

Backbone.Factlink ||= {}
class Backbone.Factlink.TextAreaView extends Backbone.Marionette.ItemView
  template: 'generic/text_area'
  events:
    #we will init autosize not on render, but on keydown: this way the
    #textarea remains small in its unfocused state.
    'keydown textarea': '_parseKeyDown'
    'keyup textarea': 'updateModel'
    'input textarea': 'updateModel'
    'click textarea': '_onClick'

  triggers:
    'focus textarea': 'focus'
    'blur textarea': 'blur'

  ui:
    inputField: 'textarea'

  templateHelpers: =>
    placeholder: @options.placeholder

  initialize: ->
    @listenTo @model, 'change', @updateDom

  onRender: -> @focusInput()

  focusInput: ->
    _.defer => @ui.inputField.focus()

  updateModel: ->
    @model.set text: @ui.inputField.val()
  updateDom: ->
    if @model.get('text') != @ui.inputField.val()
      @ui.inputField.val(@model.get('text')).trigger('autosize')

  enable: -> @ui.inputField.prop 'disabled', false
  disable:-> @ui.inputField.prop 'disabled', true

  _initAutosize: ->
    return if @autosizeInitialized
    @autosizeInitialized = true
    @ui.inputField.autosize append: '\n\n'

  _parseKeyDown: (e) ->
    @_initAutosize()
    if e.keyCode == 13 && (e.ctrlKey || e.metaKey || e.shiftKey)
      @trigger 'return'
      e.preventDefault()
      e.stopPropagation()

  insert: (text) ->
    cursorPos = @ui.inputField.prop('selectionStart')
    currentText = @model.get('text')
    textBefore = currentText.substring(0, cursorPos)
    textAfter = currentText.substring(cursorPos, currentText.length)

    if /\S$/.test(textBefore)
      text = ' ' + text
    if /^\S/.test(textAfter)
      text += ' '

    @_initAutosize()
    @model.set 'text', textBefore + text + textAfter
    @focusInput()

  _onClick: ->
    @_initAutosize() if @model.get('text')
