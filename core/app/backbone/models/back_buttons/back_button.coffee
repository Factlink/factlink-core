class window.BackButton extends Backbone.Model

  defaults:
    text: ''
    url: ''

  initialize: (attributes, options) ->
    @options = options

    # TODO: use listenTo when upgrading to new Backbone version
    @options.model.on 'change', @update, @
    @update()

  # TODO: remove when upgrading to new Backbone version
  stopListening: ->
    @options.model.off 'change', @update, @
