class window.TextInputView extends Backbone.Marionette.ItemView
  events:
    'click': 'focusInput'
    "keydown input.typeahead": "parseKeyDown"
    "keyup input.typeahead": "autoCompleteCurrentValue"

  template:
    text: '<input type="text" value="{{text}}" class="typeahead">'

  initialize: ->
    @model.on 'change', @updateValue, this

  focusInput: -> @$("input.typeahead").focus()

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

  updateValue: -> @$("input.typeahead").val(@model.get('text'))
  autoCompleteCurrentValue: -> @model.set text: @$("input.typeahead").val()

  enable: -> @$("input.typeahead").prop "disabled", false
  disable: ->@$("input.typeahead").prop "disabled", true
