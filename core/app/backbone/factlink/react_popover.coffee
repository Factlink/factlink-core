Backbone.Factlink ||= {}

window.ReactPopover = React.createBackboneClass
  displayName: 'ReactPopover'

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
    _div ['translucent-popover top'],
      _div ['factlink-popover-content'],
        @props.children
      _div ['factlink-popover-arrow']

  _tetherOptions: ->
    element: @_tooltipElement
    target: @getDOMNode().parentElement
    attachment: 'bottom center'
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
