class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    super(options)

    unless @popover?
      throw "PopoverView needs a popover property"

    @bindPopover()
    @on "render", @realOnRender, this

  bindPopover: ->
    @$el.on "click.popover", @popover.selector, =>
      @popoverToggle()
    @$el.on "click.popover_menu", @popover.popoverSelector, (e) ->
      e.stopPropagation()

  realOnRender: ->
    if @$(@popover.popoverSelector).children("li").length <= 0
      @$(@popover.selector).hide()

  popoverToggle: ->
    $popover = @$(@popover.popoverSelector)
    if $popover.is(":hidden")
      @showPopover $popover
    else
      @hidePopover $popover

  showPopover: ($popover) ->
    $popoverButton = @$(@popover.selector)
    $popover.show()
    $popoverButton.addClass "active"
    @bindWindowClick $popover

  hidePopover: ($popover) ->
    $popoverButton = @$(@popover.selector)
    $popover.hide()
    $popoverButton.removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ($popover) ->
    $(window).on "click.popover." + @cid, (e) =>
      if $(e.target).closest(@popover.selector)[0] isnt @$(@popover.selector)[0]
        @hidePopover $popover

  unbindWindowClick: ->
    $(window).off "click.popover." + @cid

  close: ->
    super()
    @unbindWindowClick()
    @$el.off "click.popover"
