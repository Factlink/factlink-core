Backbone.Factlink ||= {}

Backbone.Factlink.AddModelToCollectionMixin =
  addModel: (model, options) ->
    @options.addToCollection.add(model, options)
    model.save {},
      success: =>
        @addModelSuccess(model) if @addModelSuccess
      error: =>
        @options.addToCollection.remove(model)
        @addModelError(model) if @addModelError

  addDefaultModel: (options) -> @addModel @model, options

  addWrappedModel: -> @addModel @wrapNewModel(@model)
