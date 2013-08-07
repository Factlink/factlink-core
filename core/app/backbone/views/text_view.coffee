class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

  initialize: ->
    @listenTo @model, 'change:text', @render
