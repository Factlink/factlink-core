#= require lib/truncate_list

describe 'window.truncateList', ->

  it "returns listSize when it is smaller than maximumItems", ->
    listSize = 3
    maximumItems = 10

    result = truncateList(listSize, maximumItems)

    expect(result.number).eq listSize
    expect(result.others).eq false

  it "returns listSize when it is equal to maximumItems", ->
    listSize = 10
    maximumItems = 10

    result = truncateList(listSize, maximumItems)

    expect(result.number).eq listSize
    expect(result.others).eq false

  it "returns maximumItems-1 and shows others when listSize is larger than maximumItems", ->
    listSize = 15
    maximumItems = 10

    result = truncateList(listSize, maximumItems)

    expect(result.number).eq maximumItems-1
    expect(result.others).eq true

  it "returns listSize when maximumItems is Infinity", ->
    listSize = 15
    maximumItems = Infinity

    result = truncateList(listSize, maximumItems)

    expect(result.number).eq listSize
    expect(result.others).eq false
