# Buttons in iframes sometimes don't trigger mouseleave, hence check
# document for mousemove to be sure.
# Intended to be used with @$el in a different document (ie. iframe).
class FactlinkJailRoot.RobustHover
  constructor: (@_options) ->
    @_hovered = false

    # Use mousemove instead of mouseenter since it is more reliable
    @_options.$el.on 'mousemove', @_onMouseEnter
    @_options.$el.on 'mouseleave', @_onMouseLeave

  destroy: ->
    @_options.$el.off 'mousemove', @_onMouseEnter
    @_options.$el.off 'mouseleave', @_onMouseLeave
    $(document).off 'mousemove', @_onMouseLeave

  _onMouseEnter: =>
    return if @_hovered

    # Mouse leaves when *external* document registers mousemove
    $(document).on 'mousemove', @_onMouseLeave

    @_hovered = true
    @_options.mouseenter?()

  _onMouseLeave: =>
    return unless @_hovered

    $(document).off 'mousemove', @_onMouseLeave
    @_hovered = false
    @_options.mouseleave?()
