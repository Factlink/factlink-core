class window.SearchRouter extends Backbone.Router
  routes:
    'search': 'showSearch'

  showSearch: (params={}) ->
    Backbone.history.once 'route', (router, executed_route_name) ->
      return if executed_route_name == 'showSearch'

      $('.js-navbar-search-box').val('')

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.mainRegion.show new ReactView
      component: ReactSearchResults
        model: results

    results.fetch()
    mp_track 'Search: Top bar search',
      query: query
