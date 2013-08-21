class window.SearchController extends Backbone.Marionette.Controller

  search: (params={}) ->
    @listenTo FactlinkApp.vent, 'navigate', @close

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.closeAllContentRegions()
    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()

  onClose: ->
    $('.js-navbar-search-box').val('')
