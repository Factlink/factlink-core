class Backbone.Factlink.PopoverView extends Backbone.Marionette.ItemView
  constructor: (options) ->
    @ui = _.extend {}, @ui,
      arrow:  '.js-popover-arrow-selector'
      container: '.js-popover-container'

    @events = _.extend {}, @events,
      'click .js-popover-arrow-selector': 'togglePopoverContainer'
      'click .js-popover-container': 'stopPropagation'

    super(options)

    @on "render", @popoverOnRender, this
    @on "close", @popoverOnClose, this

  stopPropagation: (e)-> e.stopPropagation()

  popoverOnRender: ->
    if @ui.container.children("li").length <= 0
      @ui.arrow.hide()

  togglePopoverContainer: ->
    if @ui.container.is(":hidden")
      @showPopoverContainer()
    else
      @hidePopoverContainer()

  showPopoverContainer: ->
    @ui.container.show()
    @ui.arrow.addClass "active"
    @bindWindowClick()

  hidePopoverContainer: ->
    @ui.container.hide()
    @ui.arrow.removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ->
    $(window).on "click.popover." + @cid, (e) =>
      if $(e.target).closest(@uiBindings.arrow)[0] isnt @ui.arrow[0]
        @hidePopoverContainer()

  unbindWindowClick: -> $(window).off "click.popover." + @cid

  popoverOnClose: -> @unbindWindowClick()
