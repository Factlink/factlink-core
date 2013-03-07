class window.PopoverView extends Backbone.Marionette.ItemView
  template: 'generic/popover'
  className: 'help-text-container'

  ui:
    arrow: '.js-arrow'

  initialize: ->
    @on 'position', @handleposition, @

  onRender: ->
    @$el.addClass @options.side

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

