class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

window.getTextView = (text) ->
  TextView.extend
    initialize: -> @model = new Backbone.Model({text: text})