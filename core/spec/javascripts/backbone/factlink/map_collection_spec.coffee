describe 'window.mapCollection', ->
  
  mapFunction = (model) ->
    new Backbone.Model(mappedField: model.get('field'))

  it 'maps empty collection to empty collection', ->
    originalCollection = new Backbone.Collection []
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, 
      (model) -> throw "Should not be called."

    expect(resultingCollection.length).toEqual 0

  it 'maps one element collection to one element collection, without mapping', ->
    originalCollection = new Backbone.Collection [new Backbone.Model()]
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, 
      (model) -> model

    expect(resultingCollection.length).toEqual 1

  it 'maps non empty collection to non empty collection, with mapping', ->
    value = 'value'
    originalCollection = new Backbone.Collection [new Backbone.Model(field: value)]
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction

    expect(resultingCollection.length).toEqual 1
    expect(resultingCollection.first().get('mappedField')).toEqual(value)

  it 'adding a model to originalCollection adds it to resultingCollection', ->
    value = 'value'
    originalCollection = new Backbone.Collection []
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction

    originalCollection.add(new Backbone.Model(field: value))
    
    expect(resultingCollection.length).toEqual 1
    expect(resultingCollection.first().get('mappedField')).toEqual(value)

  it 'removing a model from originalCollection removes it from resultingCollection', ->
    value = 'value'
    model = new Backbone.Model(field: value)
    originalCollection = new Backbone.Collection [model]
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction
    
    originalCollection.remove(model)
    
    expect(resultingCollection.length).toEqual 0

  it 'reset originalCollection resets resultingCollection', ->
    value = 'value'
    originalCollection = new Backbone.Collection [new Backbone.Model(field: value)]
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction
    
    originalCollection.reset()
    
    expect(resultingCollection.length).toEqual 0

  it 'reset originalCollection to other state updates resultingCollection', ->
    value = 'value'
    model = new Backbone.Model(field: 'not this one')
    otherModel = new Backbone.Model(field: value)
    originalCollection = new Backbone.Collection [model]
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction
    
    originalCollection.reset(otherModel)
    
    expect(resultingCollection.length).toEqual 1
    expect(resultingCollection.first().get('mappedField')).toEqual(value)

  it 'maps non empty collection to non empty collection, with mapping of two fields', ->
    value = 'value'
    otherValue = 'other value'
    originalCollection = new Backbone.Collection [new Backbone.Model(field: value, otherField: otherValue)]
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, (model) ->
      new Backbone.Model(mappedField: model.get('field'), otherMappedField: model.get('otherField'))

    expect(resultingCollection.length).toEqual 1
    expect(resultingCollection.first().get('mappedField')).toEqual(value)
    expect(resultingCollection.first().get('otherMappedField')).toEqual(otherValue)

  it 'maps non empty collection to non empty collection, with mapping', ->
    firstValue = 'first value'
    lastValue = 'last value'
    firstModel = new Backbone.Model(field: firstValue)
    lastModel = new Backbone.Model(field: lastValue)

    originalCollection = new Backbone.Collection [firstModel, lastModel]
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction

    expect(resultingCollection.length).toEqual 2
    expect(resultingCollection.first().get('mappedField')).toEqual(firstValue)
    expect(resultingCollection.last().get('mappedField')).toEqual(lastValue)

  it 'maps when setting a model attribute', ->
    value = 'value'
    otherValue = 'other value'
    model = new Backbone.Model(field: value)
    originalCollection = new Backbone.Collection [model]
    
    resultingCollection = collectionMap new Backbone.Collection, originalCollection, mapFunction

    expect(resultingCollection.length).toEqual 1
    expect(resultingCollection.first().get('mappedField')).toEqual(value)
    model.set('field', otherValue)
    expect(resultingCollection.first().get('mappedField')).toEqual(otherValue)
