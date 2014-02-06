Backbone.Factlink ||= {}
class Backbone.Factlink.TextInputView extends Backbone.Marionette.ItemView
  events:
    'keydown .typeahead': 'parseKeyDown'
    'keyup .typeahead': '_updateModel'
    'input .typeahead': '_updateModel'

  triggers:
    'focus .typeahead': 'focus'
    'blur .typeahead': 'blur'

  ui:
    inputField: '.typeahead'

  templateHelpers: =>
    placeholder: @options.placeholder

  template: 'generic/text_input'

  initialize: ->
    @listenTo @model, 'change', @_updateHtml

  focusInput: ->
    _.defer => @ui.inputField.focus()

  parseKeyDown: (e) ->
    eventHandled = false
    switch e.keyCode
      when 13 then @trigger 'return'
      when 40 then @trigger 'down'
      when 38 then @trigger 'up'
      when 27 then @trigger 'escape'
      else eventHandled = true

    unless eventHandled
      e.preventDefault()
      e.stopPropagation()

  _updateModel: -> @model.set text: @ui.inputField.val()
  _updateHtml: ->
    if @model.get('text') != @ui.inputField.val()
      @ui.inputField.val(@model.get('text'))
