window.ReactToggleButton = React.createClass
  displayName: 'ReactToggleButton'

  render: ->
    console.log @props
    id='~'+@props.name+'_'+@props.value
    _label [],
      _input [ 'radio-toggle-button',
        type: 'radio',
        name: @props.name,
        value:  @props.value,
        id: id,
        onChange: @props.onChange,
        checked: @props.checked
      ]
      _label [ htmlFor: id ],
        @props.children
