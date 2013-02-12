class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    @ui ||= {}
    _.extend @ui,
      arrow:  '.js-popover-arrow-selector'
      container: '.js-popover-container'

    super(options)

    @bindPopover()
    @on "render", @popoverOnRender, this

  bindPopover: ->
    @$el.on "click.popover", @uiBindings.arrow, =>
      @popoverToggle()
    @$el.on "click.popover_menu", @uiBindings.container, (e) ->
      e.stopPropagation()

  popoverOnRender: ->
    if @ui.container.children("li").length <= 0
      @ui.arrow.hide()

  popoverToggle: ->
    if @ui.container.is(":hidden")
      @showPopover()
    else
      @hidePopover()

  showPopover: ->
    @ui.container.show()
    @ui.arrow.addClass "active"
    @bindWindowClick()

  hidePopover: ->
    @ui.container.hide()
    @ui.arrow.removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ->
    $(window).on "click.popover." + @cid, (e) =>
      if $(e.target).closest(@uiBindings.arrow)[0] isnt @$(@uiBindings.arrow)[0]
        @hidePopover()

  unbindWindowClick: ->
    $(window).off "click.popover." + @cid

  close: ->
    super()
    @unbindWindowClick()
    @$el.off "click.popover"
