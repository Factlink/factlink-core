class window.HelptextPopoverView extends Backbone.Marionette.ItemView
  template: 'generic/helptext_popover'
  className: 'help-text-container'

  ui:
    arrow: '.js-arrow'

  initialize: ->
    @on 'position', @onPosition, @

  onRender: ->
    @$el.addClass @options.side
    @updateMargins()

  updateMargins: ->
    alignMargin = @options.alignMargin || 18

    marginLeft = 0
    marginTop  = 0

    switch @options.align
      when 'left'
        marginLeft =  alignMargin
      when 'top'
        marginTop =   alignMargin
      when 'right'
        marginLeft = -alignMargin
      when 'bottom'
        marginTop =  -alignMargin

    @ui.arrow.css 'margin-left':  marginLeft, 'margin-top':  marginTop
    @$el.css      'margin-left': -marginLeft, 'margin-top': -marginTop

  onPosition: (offset)->
    if @options.side in ['right', 'left']
      @ui.arrow.css 'top', offset.top - (@ui.arrow.height() / 2)

    if @options.side in ['top', 'bottom']
      @ui.arrow.css 'left', offset.left - (@ui.arrow.width() / 2)
