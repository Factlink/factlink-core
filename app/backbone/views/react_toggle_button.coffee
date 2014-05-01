window.ReactToggleButton = React.createClass
  displayName: 'ReactToggleButton'

  render: ->
    _label [ 'radio-toggle-button' ],
      _input [
        type: 'radio',
        name: @props.name,
        value:  @props.value,
        onChange: @props.onChange,
        checked: @props.checked
      ]
      _span [], @props.children
