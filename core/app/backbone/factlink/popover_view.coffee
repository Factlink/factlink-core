class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    super(options)
    throw "PopoverView needs a popover property"  unless _.isArray(@popover)
    _.each @popover, @bindPopover, this
    @on "render", @realOnRender, this

  bindPopover: (obj, key) ->
    method = _.bind(@popoverToggle, this, obj, key)
    blockMethod = (e) ->
      e.stopPropagation()

    @$el.on "click.popover", obj.selector, method
    @$el.on "click.popover_menu", obj.popoverSelector, blockMethod

  realOnRender: ->
    _.each @popover, @onRenderPopover, this

  onRenderPopover: (obj, key) ->
    @$el.find(obj.selector).hide()  if @$el.find(obj.popoverSelector).children("li").length <= 0

  popoverToggle: (obj, key, e) ->
    $popover = @$el.find(obj.popoverSelector)
    if $popover.is(":hidden")
      @showPopover $popover, obj, key
    else
      @hidePopover $popover, obj, key

  showPopover: ($popover, obj, key) ->
    $popoverButton = @$el.find(obj.selector)
    $popover.show()
    $popoverButton.addClass "active"
    @bindWindowClick $popover, obj, key

  hidePopover: ($popover, obj, key) ->
    $popoverButton = @$el.find(obj.selector)
    $popover.hide()
    $popoverButton.removeClass "active"
    @unbindWindowClick key

  bindWindowClick: ($popover, obj, key) ->
    $(window).on "click.popover." + @cid + "." + key, (e) =>
      @hidePopover $popover, obj, key  if $(e.target).closest(obj.selector)[0] isnt @$el.find(obj.selector)[0]

  unbindWindowClick: (key) ->
    $(window).off "click.popover." + @cid + "." + key

  close: ->
    super()
    @$el.off "click.popover"
