Backbone.Factlink ||= {}

Backbone.Factlink.PopoverMixin =

  default_options:
    side: 'left'
    align: 'center'
    margin: 0

  popoverAdd: (selector, options) ->
    @popover_options = _.extend {}, @default_options, options

    @_popovers ?= {}
    if @_popovers[selector]?
      throw "Cannot call popoverAdd multiple times with the same selector: #{selector}"

    view = new PopoverView @popover_options

    positionedRegion = new Backbone.Factlink.PositionedRegion @popover_options
    positionedRegion.crossFade view

    container = @popover_options.container || @$el

    @_popovers[selector] = { positionedRegion, container, view }
    @listenTo? view, 'close', -> @popoverRemove(selector)

    @_popoverBindAll() unless @isClosed
    @on 'render', @_popoverBindAll
    @on 'close', @popoverResetAll

  popoverRemove: (selector, fade=true) ->
    popover = @_popovers?[selector]
    if popover?
      if fade
        popover.positionedRegion.resetFade()
      else
        popover.positionedRegion.reset()

      delete @_popovers[selector]

  popoverOpened: (selector) -> @_popovers?[selector]

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
