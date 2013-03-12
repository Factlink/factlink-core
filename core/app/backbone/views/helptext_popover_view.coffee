class window.HelptextPopoverView extends Backbone.Marionette.ItemView
  template: 'generic/helptext_popover'
  className: 'help-text-container'

  ui:
    arrow: '.js-arrow'

  initialize: ->
    @on 'position', @handlePosition, @

  onRender: ->
    @$el.addClass @options.side

  handlePosition: (position)->
    if @options.side in ['right', 'left']
      @ui.arrow.css 'top', position.top - (@ui.arrow.height() / 2)

    if @options.side in ['top', 'bottom']
      @ui.arrow.css 'left', position.left - (@ui.arrow.width() / 2)
