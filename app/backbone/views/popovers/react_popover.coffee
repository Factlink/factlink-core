convertToTetherAttachment =
  left: 'middle left'
  right: 'middle right'
  top: 'top center'
  bottom: 'bottom center'

window.ReactPopover = React.createBackboneClass
  displayName: 'ReactPopover'

  propTypes:
    attachment: React.PropTypes.oneOf(['top','right', 'bottom', 'left'])

  getDefaultProps: ->
    attachment: 'bottom'

  componentWillMount: ->
    @_tooltipElement = $("""<span style="position: absolute;
                            display: inline-block;
                            z-index: 2147483647"></span>""")[0]
    $('body').append @_tooltipElement

  componentDidMount: ->
    @_renderTooltip()

  componentDidUpdate: ->
    @_renderTooltip()

  _popoverComponent: ->
    _div [@props.className || 'translucent-popover'],
      _div ['popover-content'],
        @props.children
      _div ['popover-arrow']

  _tetherOptions: ->
    element: @_tooltipElement
    target: @getDOMNode().parentElement
    attachment: convertToTetherAttachment[@props.attachment]
    optimizations:
      moveElement: false # Warning: always moves to <body> anyway!
    constraints: [
      to: 'scrollParent'
      attachment: 'together'
      pin: true
    ]

  _renderTooltip: ->
    React.renderComponent @_popoverComponent(), @_tooltipElement

    if @_tether?
      @_tether.setOptions @_tetherOptions()
    else
      @_tether = new Tether @_tetherOptions()

  componentWillUnmount: ->
    @_tether.destroy()
    React.unmountComponentAtNode @_tooltipElement
    if @_tooltipElement.parentNode
      @_tooltipElement.parentNode.removeChild(@_tooltipElement)

  render: -> _span()
