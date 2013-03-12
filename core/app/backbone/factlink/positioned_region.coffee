Backbone.Factlink ||= {}

class Backbone.Factlink.PositionedRegion extends Backbone.Marionette.Region

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
    left: elDimensions.width / 2
    top: elDimensions.height / 2

  _tooltipCss: ->
    elDimensions = @_dimensionsOf(@$el)
    bindElDimensions = @_dimensionsOf(@$bindEl)
    bindElPosition = @_bindElPosition()
    offset = @_offsets()

    switch @options.side
      when 'left'
        left: bindElPosition.left - elDimensions.width
        top:  bindElPosition.top  + bindElDimensions.height/2 - offset.top
      when 'right'
        left: bindElPosition.left + bindElDimensions.width
        top:  bindElPosition.top  + bindElDimensions.height/2 - offset.top
      when 'top'
        left: bindElPosition.left + bindElDimensions.width/2 - offset.left
        top:  bindElPosition.top  - elDimensions.height
      when 'bottom'
        left: bindElPosition.left + bindElDimensions.width/2 - offset.left
        top:  bindElPosition.top  + bindElDimensions.height

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
