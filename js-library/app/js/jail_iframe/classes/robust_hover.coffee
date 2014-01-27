# Buttons in iframes sometimes don't trigger mouseleave, hence check
# document for mousemove to be sure.
# Intended to be used with @$el in a different document (ie. iframe).
class FactlinkJailRoot.RobustHover
  constructor: (@$el, @_callbacks) ->
    @_hovered = false

    # Use mousemove instead of mouseenter since it is more reliable
    @$el.on 'mousemove', @_onMouseEnter
    @$el.on 'mouseleave', @_onMouseLeave

  destroy: ->
    @$el.off 'mousemove', @_onMouseEnter
    @$el.off 'mouseleave', @_onMouseLeave
    $(document).off 'mousemove', @_onMouseLeave

  _onMouseEnter: =>
    return if @_hovered

    # Mouse leaves when *external* document registers mousemove
    $(document).on 'mousemove', @_onMouseLeave

    @_hovered = true
    @_callbacks.mouseenter?()

  _onMouseLeave: =>
    return unless @_hovered

    $(document).off 'mousemove', @_onMouseLeave
    @_hovered = false
    @_callbacks.mouseleave?()
