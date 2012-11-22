window.collectionMap = (collection, map) ->
  mapped_collection = collection
  for model in collection.models
    mapped_collection.add(model)
  mapped_collection
