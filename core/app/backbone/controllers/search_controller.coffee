class window.SearchController

  search: (params={}) =>
    query = params['s']

    $('#factlink_search').val(query)

    results = new SearchResults [], search: query

    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()
