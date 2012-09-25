window.collectionDifference = (type, onField, collection1, collections...) ->
   result = new type()
   reset = () ->
     forbidden_fields = _.union(( for col in collections
        if col.pluck
          col.pluck(onField)
        else
          _.pluck(col,onField)
     )...)
     diffmodels = collection1.reject (model) => model.get(onField) in forbidden_fields
     result.reset diffmodels

   collection1.on('add reset remove', reset)
   for other_collection in collections
      other_collection.on('add reset remove', reset) if other_collection.on
   reset()
   return result