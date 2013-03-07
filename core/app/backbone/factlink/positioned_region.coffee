Backbone.Factlink ||= {}

class Backbone.Factlink.PositionedRegion extends Backbone.Marionette.Region

  el: '<div style="position: absolute"></div>'

  bindToElement: ($bindEl, $offsetParent) ->
    @$bindEl = $bindEl
    @$offsetParent = $offsetParent

    @ensureEl()
    @$offsetParent.append @$el

  reset: ->
    @$el?.remove()
    super()

  updatePosition: ->
    if @currentView?
      Backbone.Factlink.asyncChecking @_visible, @_actuallyUpdatePosition, @

  _actuallyUpdatePosition: ->
    @_checkOffsetParent()
    @currentView.trigger 'position', @_offsets()
    @$el.css @_tooltipCss()

  _offsets: ->
    elPosition = @_extendedPosition(@$el)
    left: elPosition.width / 2
    top: elPosition.height / 2

  _tooltipCss: ->
    elPosition = @_extendedPosition(@$el)
    bindElPosition = @_extendedPosition(@$bindEl)
    offset = @_offsets()

    switch @options.side
      when 'left'
        left: bindElPosition.left - elPosition.width
        top:  bindElPosition.top  + bindElPosition.height/2 - offset.top
      when 'right'
        left: bindElPosition.left + bindElPosition.width
        top:  bindElPosition.top  + bindElPosition.height/2 - offset.top
      when 'top'
        left: bindElPosition.left + bindElPosition.width/2 - offset.left
        top:  bindElPosition.top  - elPosition.height
      when 'bottom'
        left: bindElPosition.left + bindElPosition.width/2 - offset.left
        top:  bindElPosition.top  + bindElPosition.height

  _extendedPosition: ($el) ->
    _.extend $el.position(), # .position() is relative to the offsetParent
      width: $el.outerWidth()
      height: $el.outerHeight()

  _checkOffsetParent: ->
    $actualOffsetParent = @$bindEl.offsetParent()
    unless @$offsetParent.is($actualOffsetParent)
      console.error "Actual offsetParent is different from the specified one: ", $actualOffsetParent, @$offsetParent

  _visible: -> @$offsetParent.is ":visible"
