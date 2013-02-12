class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    @ui = _.extend {}, @ui,
      arrow:  '.js-popover-arrow-selector'
      container: '.js-popover-container'

    @events = _.extend {}, @events,
      'click .js-popover-arrow-selector': 'popoverToggle'
      'click .js-popover-container': 'stopPropagation'

    super(options)

    @on "render", @popoverOnRender, this
    @on "close", @popoverOnClose, this

  stopPropagation: (e)-> e.stopPropagation()

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

  popoverOnClose: ->
    @unbindWindowClick()
