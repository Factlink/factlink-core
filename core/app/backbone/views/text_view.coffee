class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

  initialize: ->
    @model ?= new Backbone.Model text: @options.text

    @listenTo @model, 'change:text', @render
