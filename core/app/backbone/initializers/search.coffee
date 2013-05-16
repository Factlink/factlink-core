FactlinkApp.addInitializer (options) ->

  $('#factlink_search_form').on 'submit', ->
    url = '/search?s=' + encodeURIComponent $('#factlink_search').val()
    Backbone.history.navigate url, true
    false
