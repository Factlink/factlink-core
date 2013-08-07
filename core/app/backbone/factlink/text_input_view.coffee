Backbone.Factlink ||= {}
class Backbone.Factlink.TextInputView extends Backbone.Marionette.ItemView
  events:
    'click': 'focusInput'
    'keydown .typeahead': 'parseKeyDown'
    'keyup .typeahead': 'updateModel'
    'input .typeahead': 'updateModel'

  triggers:
    'focus .typeahead': 'focus'
    'blur .typeahead': 'blur'

  templateHelpers: =>
    placeholder: @options.placeholder

  template: 'generic/text_input'

  initialize: ->
    @listenTo @model, 'change', @updateHtml

  focusInput: -> @$inputField().focus()

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

  updateModel: -> @model.set text: @$inputField().val()
  updateHtml: ->
    if @model.get('text') != @$inputField().val()
      @$inputField().val(@model.get('text'))

  enable: -> @$inputField().prop 'disabled', false
  disable: ->@$inputField().prop 'disabled', true

  $inputField: -> @$('.typeahead')
