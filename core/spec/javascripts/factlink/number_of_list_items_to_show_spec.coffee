#= require lib/number_of_list_items_to_show

describe 'window.numberOfListItemsToShow', ->

  it "returns listSize when it is smaller than maximumItems", ->
    listSize = 3
    maximumItems = 10

    expect(numberOfListItemsToShow(listSize, maximumItems)).eq listSize

  it "returns listSize when it is equal to maximumItems", ->
    listSize = 10
    maximumItems = 10

    expect(numberOfListItemsToShow(listSize, maximumItems)).eq listSize

  it "returns maximumItems-1 when listSize is larger than maximumItems", ->
    listSize = 15
    maximumItems = 10

    expect(numberOfListItemsToShow(listSize, maximumItems)).eq maximumItems-1
