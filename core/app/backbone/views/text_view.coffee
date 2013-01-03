class window.TextView extends Backbone.Marionette.ItemView
  template: 'generic/text'
  tag: 'span'

  initialize: ->
    this.bindTo(this.model, 'change:text', this.render)
