class window.SearchController
  search: (params={}) =>
    results = new SearchResults [], search: params['s']

    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()
