class window.ReactView extends Backbone.View
  tagName: 'span'
  render: ->
    React.renderComponent(@options.component, @el)

window.reactShow = (region, component) ->
  region.show new ReactView(component: component)

window.R = React.DOM
