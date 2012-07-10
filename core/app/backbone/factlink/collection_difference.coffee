window.collectionDifference = (type, onField,collection1, collections...) ->
   result = new type()
   reset = () ->
     forbidden_fields = _.union( (col.pluck(onField) for col in collections)... )
     diffmodels = collection1.reject (model) => model.get(onField) in forbidden_fields
     result.reset diffmodels

   collection1.on('add reset remove', reset)
   other_collection.on('add reset remove', reset) for other_collection in collections
   reset()
   return result