class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

  initialize: ->
    @template = 'generic/text_unescaped' if @options.unescaped
    @listenTo @model, 'change:text', @render
