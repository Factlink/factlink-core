Backbone.Factlink ||= {}

class Backbone.Factlink.PositionedRegion extends Backbone.Factlink.CrossFadeRegion

  el: '<div style="position: absolute"></div>'

  bindToElement: ($bindEl, $container) ->
    @$bindEl = $bindEl
    @$container = $container

    @ensureEl()
    @$container.append @$el

  reset: ->
    @$el?.remove()
    super()

  updatePosition: ->
    if @currentView?
      Backbone.Factlink.asyncChecking @_visible, @_actuallyUpdatePosition, @

  _actuallyUpdatePosition: ->
    @_checkContainer()
    @currentView.trigger 'position', @_offsets()
    @$el.css @_tooltipCss()

  _offsets: ->
    elDimensions = @_dimensionsOf(@$el)

    switch @options.align || 'center'
      when 'left', 'top'
        left: 0
        top:  0
      when 'right'
        left: elDimensions.width
        top:  0
      when 'bottom'
        left: 0
        top:  elDimensions.height
      when 'center'
        left: elDimensions.width / 2
        top:  elDimensions.height / 2
      else
        throw "Invalid options.align: #{@options.align}"

  _tooltipCss: ->
    elDimensions = @_dimensionsOf(@$el)
    bindElDimensions = @_dimensionsOf(@$bindEl)
    bindElPosition = @_bindElPosition()
    offset = @_offsets()
    margin = @options.margin || 0

    switch @options.side
      when 'left'
        left: bindElPosition.left - elDimensions.width - margin
        top:  bindElPosition.top  + bindElDimensions.height/2 - offset.top
      when 'right'
        left: bindElPosition.left + bindElDimensions.width + margin
        top:  bindElPosition.top  + bindElDimensions.height/2 - offset.top
      when 'top'
        left: bindElPosition.left + bindElDimensions.width/2 - offset.left
        top:  bindElPosition.top  - elDimensions.height - margin
      when 'bottom'
        left: bindElPosition.left + bindElDimensions.width/2 - offset.left
        top:  bindElPosition.top  + bindElDimensions.height + margin
      else
        throw "Invalid options.side: #{@options.side}"

  _bindElPosition: ->
    elOffset = @$bindEl.offset()
    containerOffset = @$container.offset()

    left: elOffset.left - containerOffset.left
    top:  elOffset.top  - containerOffset.top

  _dimensionsOf: ($el) ->
    width: $el.outerWidth()
    height: $el.outerHeight()

  _checkContainer: ->
    unless @$container.css('position') in ['relative', 'absolute', 'fixed']
      console.error "Container is not positioned", @$container

  _visible: -> @$container.is ":visible"
