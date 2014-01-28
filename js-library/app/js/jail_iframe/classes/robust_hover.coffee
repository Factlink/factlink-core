class FactlinkJailRoot.RobustHover
  constructor: (@_options) ->
    @_hovered = false

    # Use mousemove instead of mouseenter since it is more reliable
    @_options.$el.on 'mousemove', @_onMouseEnter
    @_options.$el.on 'mouseleave', @_onMouseLeave

  destroy: ->
    @_options.$el.off 'mousemove', @_onMouseEnter
    @_options.$el.off 'mouseleave', @_onMouseLeave
    @_options.$externalDocument?.off 'mousemove', @_onMouseLeave

  _onMouseEnter: =>
    return if @_hovered

    # Mouse leaves when *external* document registers mousemove
    @_options.$externalDocument?.on 'mousemove', @_onMouseLeave

    @_hovered = true
    @_options.mouseenter?()

  _onMouseLeave: =>
    return unless @_hovered

    @_options.$externalDocument?.off 'mousemove', @_onMouseLeave
    @_hovered = false
    @_options.mouseleave?()
