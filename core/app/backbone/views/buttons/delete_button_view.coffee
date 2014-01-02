class window.DeleteButtonView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'delete-button'

  template: 'buttons/delete_button'

  events:
    'click .js-first': '_toggleButton'
    'mouseleave': '_closeButtonOnMouseLeave'

  triggers:
    'click .js-second': 'delete'

  templateHelpers: =>
    caption: @options.caption || 'Delete'

  onRender: ->
    if @options.opened
      @$el.addClass 'delete-button-open'

  _toggleButton: ->
    @$el.toggleClass 'delete-button-open'

  _closeButtonOnMouseLeave: ->
    return if @options.opened

    @$el.removeClass 'delete-button-open'
