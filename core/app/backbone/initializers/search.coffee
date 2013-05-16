FactlinkApp.addInitializer (options) ->

  $('.js-navbar-search-form').on 'submit', ->
    url = '/search?s=' + encodeURIComponent $('.js-navbar-search-box').val()
    Backbone.history.navigate url, true
    false
