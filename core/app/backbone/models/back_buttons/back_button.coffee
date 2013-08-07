class window.BackButton extends Backbone.Model

  defaults:
    text: ''
    url: ''

  initialize: (attributes, options) ->
    @options = options

    @listenTo @options.model, 'change', @update
    @update()
