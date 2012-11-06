describe 'window.collectionDifference', ->
  type = Backbone.Collection
  collection1 = null
  collections = null
  result = null
  models = [0..10].map (i) -> new Backbone.Model(someField: i)

  beforeEach ->
    collection1 = new type(models[1..4])
    collections = [new type(models[2..3]), new type(models[5..6])]
    result = collectionDifference(type, 'someField', collection1, collections...)

  it 'deletes the elements from "collections" that match "someField"', ->
    expect(result.pluck('someField')).toEqual([1, 4])

  it 'should work when adding elements to "collection1"', ->
    collection1.add(models[6])
    collection1.add(models[7])
    expect(result.pluck('someField')).toEqual([1, 4, 7])

  it 'should work when removing elements from "collection1"', ->
    collection1.remove(models[3])
    collection1.remove(models[4])
    expect(result.pluck('someField')).toEqual([1])

  it 'should work when resetting "collection1"', ->
    collection1.reset(models[1..7])
    expect(result.pluck('someField')).toEqual([1, 4, 7])

  it 'should work when adding elements to "collections"', ->
    collections[0].add(models[1])
    collections[1].add(models[1])
    collections[1].add(models[4])
    expect(result.pluck('someField')).toEqual([])

  it 'should work when removing elements from "collections"', ->
    collections[0].remove(models[2])
    collections[1].remove(models[6])
    expect(result.pluck('someField')).toEqual([1, 2, 4])

  it 'should work when resetting "collections"', ->
    collections[0].reset(models[1..2])
    collections[1].reset(models[2..3])
    expect(result.pluck('someField')).toEqual([4])

  it 'should work when using different models with the same fields', ->
    collections[0].reset([new Backbone.Model(someField: 2), new Backbone.Model(someField: 3)])
    expect(result.pluck('someField')).toEqual([1, 4])

  it 'should ignore other fields', ->
    collection1.reset([new Backbone.Model(someField: 1, otherField: 10), new Backbone.Model(someField: 2, otherField: 3)])
    collections[0].reset([new Backbone.Model(someField: 2, otherField: 10), new Backbone.Model(someField: 3, otherField: 2)])
    expect(result.pluck('otherField')).toEqual([10])

  it 'should work with arrays and objects instead of collections and models', ->
    result = collectionDifference(type, 'someField', collection1, [{someField: 2}, {someField: 3}], collections[1])
    expect(result.pluck('someField')).toEqual([1, 4])

  it 'should work with subsequent add, removes, and resets', ->
    collection1.add(models[6])
    collection1.add(models[7])
    collection1.reset(models[1..7])
    collection1.remove(models[7])
    collection1.remove(models[6])
    collections[0].add(models[1])
    collections[1].add(models[1])
    collections[1].add(models[4])
    collections[0].add(models[1])
    collections[0].reset(models[2..4])
    collections[0].remove(models[4])
    collections[1].remove(models[1])
    # collections[1].remove(models[4])
    expect(result.pluck('someField')).toEqual([1, 4])
