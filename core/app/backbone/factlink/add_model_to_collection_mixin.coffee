Backbone.Factlink ||= {}

Backbone.Factlink.AddModelToCollectionMixin =
  addModel: (model) ->
    @options.addToCollection.add(model)
    model.save {},
      success: =>
        @addModelSuccess(model) if @addModelSuccess
      error: =>
        @options.addToCollection.remove(model)
        @addModelError(model) if @addModelError

  addDefaultModel: -> @addModel @model

  addWrappedModel: -> @addModel @wrapNewModel(@model)
