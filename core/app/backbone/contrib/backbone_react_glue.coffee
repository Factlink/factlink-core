class window.ReactView extends Backbone.View
  tagName: 'span'
  render: ->
    React.renderComponent(@options.component, @el)

window.R = React.DOM
