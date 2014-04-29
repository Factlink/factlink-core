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

