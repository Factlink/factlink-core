window.collectionDifference = (type, collection1, collections...) ->
   result = new type()
   reset = () ->
     forbidden_ids = _.union( (col.pluck('id') for col in collections)... )
     diffmodels = collection1.reject (model) => model.id in forbidden_ids
     result.reset diffmodels

   collection1.on('add reset remove', reset)
   other_collection.on('add reset remove', reset) for other_collection in collections
   reset()
   return result