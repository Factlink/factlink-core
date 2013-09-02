class window.SearchController extends Backbone.Marionette.Controller

  showSearch: (params={}) ->
    $(window).scrollTop 0
    @listenTo FactlinkApp.vent, 'load_url', @close

    query = params['s']
    $('.js-navbar-search-box').val(query)
    results = new SearchResults [], search: query

    FactlinkApp.closeAllContentRegions()
    FactlinkApp.mainRegion.show new SearchResultView
      collection: results

    results.fetch()

  onClose: ->
    $('.js-navbar-search-box').val('')
