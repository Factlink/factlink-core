class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

window.getTextView = (text) ->
  tv = TextView.extend
    initialize: -> @model = new Backbone.Model({text: text})
  return new tv()