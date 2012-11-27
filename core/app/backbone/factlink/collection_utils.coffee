window.collectionDifference = (args...) ->
  utils = new CollectionUtils()
  utils.difference args...

window.collectionMap = (args...) ->
  utils = new CollectionUtils()
  utils.map(args...)

class window.CollectionUtils
  constructor: (eventbinder)->
    @eventbinder = eventbinder || new Backbone.Marionette.EventBinder

  bindTo: (args...)=>
    @eventbinder.bindTo args...

  difference: (resultCollection, onField, collection1, collections...) =>
    reset = ->
     forbidden_fields = _.union(( for col in collections
        if col.pluck
          col.pluck(onField)
        else
          _.pluck(col,onField)
     )...)
     diffmodels = collection1.reject (model) => model.get(onField) in forbidden_fields
     resultCollection.reset diffmodels

    collection1.on('add reset remove change', reset)
    for other_collection in collections
      other_collection.on('add reset remove change', reset) if other_collection.on
    reset()
    resultCollection

  map: (resultCollection, collection, mapFunction) =>
    reset = ->
      resultCollection.reset()
      for model in collection.models
        resultCollection.add mapFunction(model)

    collection.on 'add remove reset change', reset
    reset()
    resultCollection

