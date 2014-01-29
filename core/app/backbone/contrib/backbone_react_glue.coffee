class window.ReactView extends Backbone.View
  tagName: 'span'
  initialize: (options) ->
    throw "You haven't defined component, silly developer" unless options.component

  render: ->
    React.renderComponent(@options.component, @el)

window.R = React.DOM
