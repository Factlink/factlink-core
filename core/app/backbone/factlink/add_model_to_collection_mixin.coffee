Backbone.Factlink ||= {}

Backbone.Factlink.AddModelToCollectionMixin =
  addModel: ->
    console.info('adding', @model.get('title'), 'to collection', @options.addToCollection)
    if @wrapNewModel
      model = @wrapNewModel(@model)
    else
      model = @model
    @options.addToCollection.add(model)
    model.save({},{
      success: =>
        if @addModelSuccess
          @addModelSuccess(model)
      error: =>
        @options.addToCollection.remove(model)
        if addModelError
          @addModelError(model)
    })
