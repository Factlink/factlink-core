Backbone.Factlink ||= {}

oldZIndex = 0
focusElement = (element) ->
  oldZIndex = $(element).css('z-index')
  $(element).css('z-index', 110)

unFocusElement = (element) ->
  $(element).css('z-index', oldZIndex)
  oldZIndex = 0

Backbone.Factlink.PopoverMixin =

  default_options:
    side: 'left'
    align: 'center'
    show_overlay: false
    focus_on: null
    margin: 0
    orthogonalOffset: 0
    helpStyle: true

  popoverAdd: (selector, options) ->
    @popover_options = _.extend {}, @default_options, options

    @_popovers ?= {}
    if @_popovers[selector]?
      throw "Cannot call popoverAdd multiple times with the same selector: #{selector}"

    unless options.contentView?
      @popover_options.contentView = new Backbone.Marionette.ItemView template: options.contentTemplate

    view = new PopoverView @popover_options

    FactlinkApp.Overlay.show() if @popover_options['show_overlay']
    focusElement(@popover_options['focus_on']) if @popover_options['focus_on']

    positionedRegion = new Backbone.Factlink.PositionedRegion @popover_options
    positionedRegion.crossFade view

    container = @popover_options.container || @$el

    @_popovers[selector] = { positionedRegion, container, view }

    @_popoverBindAll() unless @isClosed
    @on 'render', @_popoverBindAll
    @on 'close', @popoverResetAll

  popoverRemove: (selector, fade=true) ->
    popover = @_popovers[selector]
    if popover?
      FactlinkApp.Overlay.hide() if @popover_options['show_overlay']
      unFocusElement(@popover_options['focus_on']) if @popover_options['focus_on']

      if fade
        popover.positionedRegion.resetFade()
      else
        popover.positionedRegion.reset()

      delete @_popovers[selector]

  _popoverBindAll: ->
    for selector, popover of @_popovers
      $bindEl = @$(selector).first()
      popover.positionedRegion.bindToElement($bindEl, popover.container)

    @_popoverUpdateAll()

  _popoverUpdateAll: ->
    for selector, popover of @_popovers
      popover.positionedRegion.updatePosition()

  popoverResetAll: ->
    for selector, popover of @_popovers
      @popoverRemove(selector, false)
