window.collectionMap = (resultCollection, collection, mapFunction) ->
  reset = ->
    resultCollection.reset()
    for model in collection.models
      resultCollection.add mapFunction(model)
  
  collection.on 'add remove reset', reset  
  reset()
  resultCollection
