#= require lib/truncated_list_sizes

describe 'window.truncatedListSizes', ->

  it "returns listSize when it is smaller than maximumItems", ->
    listSize = 3
    maximumItems = 10

    result = truncatedListSizes(listSize, maximumItems)

    expect(result.numberToShow).eq listSize
    expect(result.numberOfOthers).eq 0

  it "returns listSize when it is equal to maximumItems", ->
    listSize = 10
    maximumItems = 10

    result = truncatedListSizes(listSize, maximumItems)

    expect(result.numberToShow).eq listSize
    expect(result.numberOfOthers).eq 0

  it "returns maximumItems-1 and sets numberOfOthers when listSize is larger than maximumItems", ->
    listSize = 15
    maximumItems = 10

    result = truncatedListSizes(listSize, maximumItems)

    expect(result.numberToShow).eq maximumItems-1
    expect(result.numberOfOthers).eq listSize-maximumItems+1

  it "returns listSize when maximumItems is Infinity", ->
    listSize = 15
    maximumItems = Infinity

    result = truncatedListSizes(listSize, maximumItems)

    expect(result.numberToShow).eq listSize
    expect(result.numberOfOthers).eq 0
