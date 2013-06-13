#= require jquery.autosize

#we're using jquery autosize rather than jquery elastic since this works
#even if initialized before the element is in the DOM.

Backbone.Factlink ||= {}
class Backbone.Factlink.TextAreaView extends Backbone.Marionette.ItemView
  template: 'generic/text_area'
  events:
    # 'click': 'focusInput'
    'keydown .typeahead': 'parseKeyDown'
    'keyup .typeahead': 'updateModel'

  triggers:
    'focus .typeahead': 'focus'
    'blur .typeahead': 'blur'

  templateHelpers: =>
    placeholder: @options.placeholder

  initialize: ->
    @bindTo @model, 'change', @updateHtml, this

  # focusInput: -> @$inputField().focus()

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

  updateModel: ->
    @model.set text: @$inputField().val()
  updateHtml: ->
    if @model.get('text') != @$inputField().val()
      @$inputField().val(@model.get('text')).trigger('autosize')

  enable: -> @$inputField().prop 'disabled', false
  disable: ->@$inputField().prop 'disabled', true

  $inputField: -> @$('.typeahead')
  onRender: ->
    @$el.find('textarea').autosize append: '\n\n'
