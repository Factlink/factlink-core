class window.SearchController extends Backbone.Marionette.Controller

  showSearch: (params={}) ->
    @listenTo Backbone.history, 'route', (router, executed_route_name) ->
      return if executed_route_name == 'showSearch'

      @close()

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.mainRegion.close()
    FactlinkApp.mainRegion.show new ReactView
      component: ReactSearchResults
        model: results

    results.fetch()
    mp_track 'Search: Top bar search',
      query: query

  onClose: -> $('.js-navbar-search-box').val('')
