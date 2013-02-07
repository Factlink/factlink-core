class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    super(options)

    unless @popover?
      throw "PopoverView needs a popover property"

    @bindPopover @popover
    @on "render", @realOnRender, this

  bindPopover: (obj) ->
    method = _.bind(@popoverToggle, this, obj)
    blockMethod = (e) ->
      e.stopPropagation()

    @$el.on "click.popover", obj.selector, method
    @$el.on "click.popover_menu", obj.popoverSelector, blockMethod

  realOnRender: ->
    @onRenderPopover @popover

  onRenderPopover: (obj) ->
    @$(obj.selector).hide()  if @$(obj.popoverSelector).children("li").length <= 0

  popoverToggle: (obj, e) ->
    $popover = @$(obj.popoverSelector)
    if $popover.is(":hidden")
      @showPopover $popover, obj
    else
      @hidePopover $popover, obj

  showPopover: ($popover, obj) ->
    $popoverButton = @$(obj.selector)
    $popover.show()
    $popoverButton.addClass "active"
    @bindWindowClick $popover, obj

  hidePopover: ($popover, obj) ->
    $popoverButton = @$(obj.selector)
    $popover.hide()
    $popoverButton.removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ($popover, obj) ->
    $(window).on "click.popover." + @cid, (e) =>
      @hidePopover $popover, obj if $(e.target).closest(obj.selector)[0] isnt @$(obj.selector)[0]

  unbindWindowClick: ->
    $(window).off "click.popover." + @cid

  close: ->
    super()
    @unbindWindowClick()
    @$el.off "click.popover"
