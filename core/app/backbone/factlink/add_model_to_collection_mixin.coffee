Backbone.Factlink ||= {}

Backbone.Factlink.AddModelToCollectionMixin =
  addModel: ->
    if @wrapNewModel
      model = @wrapNewModel(@model)
    else
      model = @model
    @options.addToCollection.add(model)
    model.save {},
      success: =>
        @addModelSuccess(model) if @addModelSuccess
      error: =>
        @options.addToCollection.remove(model)
        @addModelError(model) if @addModelError
