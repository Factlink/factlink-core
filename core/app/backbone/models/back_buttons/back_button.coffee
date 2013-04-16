class window.BackButton extends Backbone.Model

  initialize: (attributes, options) ->
    @model = options.model

    # TODO: use listenTo when upgrading to new Backbone version
    @model.on 'change', @update, @
    @update()

  # TODO: remove when upgrading to new Backbone version
  stopListening: ->
    @model.off 'change', @update, @
