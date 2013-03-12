class window.HelptextPopoverView extends Backbone.Marionette.Layout
  template: 'tooltips/helptext_popover'
  className: 'help-text-container'

  ui:
    arrow: '.js-arrow'

  regions:
    contentRegion: '.js-help-text-content'

  initialize: ->
    @on 'position', @handleposition, @

  onRender: ->
    @$el.addClass @options.side

    @contentRegion.show @options.view if @options.view

  handleposition: (position)->
    top = 0
    left = 0

    if @options.side in ['right', 'left']
      top = position.top - (@ui.arrow.height() / 2)

    if @options.side in ['top', 'bottom']
      left = position.left - (@ui.arrow.width() / 2)

    if @options.side is 'left'
      left = position.left * 2 - @ui.arrow.width()

    if @options.side is 'top'
      top = position.top * 2 - @ui.arrow.height()

    @ui.arrow.css
      top: top
      left: left

