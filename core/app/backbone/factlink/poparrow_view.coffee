class Backbone.Factlink.PoparrowView extends Backbone.Marionette.ItemView

  arrowSelector: '.js-poparrow-arrow-selector'

  constructor: (options) ->
    @ui = _.extend {}, @ui,
      arrow: @arrowSelector
      container: '.js-poparrow-container'

    @events = _.extend {}, @events,
      'click .js-poparrow-arrow-selector': 'togglePoparrowContainer'
      'click .js-poparrow-container': 'stopPropagation'

    super(options)

    @on "render", @poparrowOnRender, this
    @on "close", @poparrowOnClose, this

  stopPropagation: (e)-> e.stopPropagation()

  poparrowOnRender: ->
    if @ui.container.children("li").length <= 0
      @ui.arrow.hide()

  togglePoparrowContainer: ->
    if @ui.container.is(":hidden")
      @showPoparrowContainer()
    else
      @hidePoparrowContainer()

  showPoparrowContainer: ->
    @ui.container.show()
    @ui.arrow.addClass "active"
    @bindWindowClick()

  hidePoparrowContainer: ->
    @ui.container.hide()
    @ui.arrow.removeClass "active"
    @unbindWindowClick()

  bindWindowClick: ->
    $(window).on "click.poparrow." + @cid, (e) =>
      if $(e.target).closest(@arrowSelector)[0] isnt @ui.arrow[0]
        @hidePoparrowContainer()

  unbindWindowClick: -> $(window).off "click.poparrow." + @cid

  poparrowOnClose: -> @unbindWindowClick()
