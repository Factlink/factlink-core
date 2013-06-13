#= require jquery.autosize

#we're using jquery autosize rather than jquery elastic since this works
#even if initialized before the element is in the DOM.

Backbone.Factlink ||= {}
class Backbone.Factlink.TextAreaView extends Backbone.Marionette.ItemView
  template: 'generic/text_area'
  events:
    'keyup textarea': 'updateModel'

  triggers:
    'focus textarea': 'focus'
    'blur textarea': 'blur'

  ui:
    inputField: 'textarea'

  className: 'TextAreaView'

  templateHelpers: =>
    placeholder: @options.placeholder

  initialize: ->
    @bindTo @model, 'change', @updateDom, this
    @on 'focus', @initAutosize

  updateModel: ->
    @model.set text: @ui.inputField.val()
  updateDom: ->
    if @model.get('text') != @ui.inputField.val()
      @ui.inputField.val(@model.get('text')).trigger('autosize')

  enable: -> @ui.inputField.prop 'disabled', false
  disable:-> @ui.inputField.prop 'disabled', true

  initAutosize: ->
    return if @autosizeInitialized
    @autosizeInitialized = true
    @ui.inputField.autosize append: '\n\n'
