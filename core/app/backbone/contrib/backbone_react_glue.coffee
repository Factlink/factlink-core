class window.ReactView extends Backbone.View
  tagName: 'span'
  initialize: (options) ->
    throw "You haven't defined component, silly developer" unless options.component
    @on 'show', ->
      React.renderComponent(@options.component, @el)

window.R = React.DOM

define_tag = (tag) ->
  return unless {}.hasOwnProperty.call(React.DOM, tag) and tag != 'injection'

  window['_' + tag] = (attrs, children...) ->
    if Array.isArray(attrs)
      options = { className: '' }
      for attr in attrs
        if typeof attr == 'string'
          options.className += ' ' + attr
        else
          options[key] = value for key, value of attr

      React.DOM[tag](options, children...)
    else
      React.DOM[tag](attrs, children...)


define_tag tag for tag, method of React.DOM

