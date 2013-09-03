class window.SearchController extends Backbone.Marionette.Controller

  showSearch: (params={}) ->
    @listenTo Backbone.history, 'route', (router, name) ->
      return if name == 'showSearch'

      $('.js-navbar-search-box').val('')

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.closeAllContentRegions()
    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()
