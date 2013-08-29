window.collectionDifference = (args...) ->
  utils = new CollectionUtils()
  utils.difference args...

window.collectionMap = (args...) ->
  utils = new CollectionUtils()
  utils.map(args...)

class window.CollectionUtils
  constructor: (eventAggregator)->
    @eventAggregator = eventAggregator || new Backbone.Wreqr.EventAggregator

  listenTo: (args...)=>
    @eventAggregator.listenTo args...

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

    @listenTo collection1, 'add reset remove change', reset
    for collection in collections
      if collection.on?
        @listenTo collection, 'add reset remove change', reset

    reset()
    resultCollection

  union: (resultCollection, collections...)->
    reset = ->
      resultCollection.reset(_.union (col.models for col in collections)...)

    for collection in collections
      if collection.on
        @listenTo collection, 'add reset remove change', reset

    reset()
    resultCollection

  map: (resultCollection, collection, mapFunction) =>
    reset = ->
      resultCollection.reset()
      for model in collection.models
        resultCollection.add mapFunction(model)

    @listenTo collection, 'add remove reset change', reset
    reset()
    resultCollection
