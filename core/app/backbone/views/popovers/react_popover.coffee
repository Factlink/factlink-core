window.ReactPopover = React.createBackboneClass
  displayName: 'ReactPopover'

  getDefaultProps: ->
    vertical: "bottom"
    horizontal: "center"

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
    _div ['translucent-popover',
          @props.vertical unless @props.vertical == 'middle'
          @props.horizontal unless @props.horizontal == 'center'
        ],
      _div ['factlink-popover-content'],
        @props.children
      _div ['factlink-popover-arrow']

  _tetherOptions: ->
    element: @_tooltipElement
    target: @getDOMNode().parentElement
    attachment: @props.vertical + ' ' + @props.horizontal
    optimizations:
      moveElement: false # Warning: always moves to <body> anyway!

  _renderTooltip: ->
    React.renderComponent @_popoverComponent(), @_tooltipElement

    if @_tether?
      @_tether.setOptions @_tetherOptions()
    else
      @_tether = new Tether @_tetherOptions()

  componentWillUnmount: ->
    @_tether.destroy()
    React.unmountComponentAtNode @_tooltipElement
    @_tooltipElement.remove()

  render: -> _span()
