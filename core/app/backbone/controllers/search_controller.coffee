class window.SearchController extends Backbone.Marionette.Controller

  showSearch: (params={}) ->
    @listenTo Backbone.history, 'route', (router, executed_route_name) ->
      return if executed_route_name == 'showSearch'

      @close()

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.mainRegion.close()
    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()
    mp_track 'Search: Top bar search'

  onClose: -> $('.js-navbar-search-box').val('')
