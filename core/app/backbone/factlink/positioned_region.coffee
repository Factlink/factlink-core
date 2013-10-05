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

  # WARNING: This function is a bit of a dirty hack:
  # Normally, we can just use plain DOM methods, but for SVG...
  # For SVG, we need to compute the bounding box; but this isn't trivial.
  # there's a method getBoundingClientRect, but there are cross-browser issues
  # so instead we use getBBox, which works, but results in the untransformed
  # svg-space coordinates.  We then simply assume there's no transformation
  # (this assumption is false for scaled factwheels) and add the BBox info
  # to the offsetWidth etc dom info of the nearest non-svg ancestor.  This
  #  assumes that ancestor's block exactly wraps the SVG, which may not be
  #  the case in general, but is for our raphael-based svgs.

  # The various not entirely valid assumptions mean that our layout
  # is a little fuzzy, which isn't really an issue for tooltips, fortunately.
  # to avoid bad cases of overlap, we add a little extra margin.
  _dimensionsOf: ($el) ->
    if bbox = $el[0].getBBox?()
      width: bbox.width + 6
      height: bbox.height+ 6
    else
      width: $el.outerWidth()
      height: $el.outerHeight()

  _checkContainer: ->
    unless @$container.css('position') in ['relative', 'absolute', 'fixed']
      console.error "Container is not positioned", @$container

  _visible: -> @$container.is ":visible"
