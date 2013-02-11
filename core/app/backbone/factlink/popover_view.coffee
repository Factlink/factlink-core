class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  popover:
    selector: '.js-popover-arrow-selector'
    popoverSelector: '.js-popover-container'

  constructor: (options) ->
    super(options)

    unless @popover?
      throw "PopoverView needs a popover property"

    @bindPopover()
    @on "render", @popoverOnRender, this

  bindPopover: ->
    @$el.on "click.popover", @popover.selector, =>
      @popoverToggle()
    @$el.on "click.popover_menu", @popover.popoverSelector, (e) ->
      e.stopPropagation()

  popoverOnRender: ->
    if @$(@popover.popoverSelector).children("li").length <= 0
      @$(@popover.selector).hide()

  $popover: -> @$(@popover.popoverSelector)
  $popoverButton: -> @$(@popover.selector)

  popoverToggle: ->
    if @$popover().is(":hidden")
      @showPopover()
    else
      @hidePopover()

  showPopover: ->
    @$popover().show()
    @$popoverButton().addClass "active"
    @bindWindowClick()

  hidePopover: ->
    @$popover().hide()
    @$popoverButton().removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ->
    $(window).on "click.popover." + @cid, (e) =>
      if $(e.target).closest(@popover.selector)[0] isnt @$(@popover.selector)[0]
        @hidePopover()

  unbindWindowClick: ->
    $(window).off "click.popover." + @cid

  close: ->
    super()
    @unbindWindowClick()
    @$el.off "click.popover"
