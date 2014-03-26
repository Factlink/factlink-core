showComponent = (component)->
  el = document.querySelector('#main-wrapper')
  React.renderComponent(component, el)

class FactlinkRouter extends Backbone.Router
  routes:
    'feed': ->
      showComponent ReactFeedSelection()
      mp_track 'Viewed feed'

    'search': 'search' # must be named

    ':username/edit': ->
      showComponent ReactProfileEdit model: currentSession.user()

    ':username/notification-settings': ->
      showComponent ReactNotificationSettings model: currentSession.user()

    ':username/change-password': ->
      showComponent ReactChangePassword model: currentSession.user().password()

    ':username': (username) ->
      user = new User(username: username)
      user.fetch()

      showComponent ReactProfile model: user

  search: (params={}) ->
    @once 'route', (route) ->
      return if route == 'search'

      $('.js-navbar-search-box').val('')

    query = params['s']
    $('.js-navbar-search-box').val(query)

    results = new SearchResults [], search: query
    results.fetch()

    showComponent ReactSearchResults model: results

    mp_track 'Search: Top bar search',
      query: query


Factlink.siteInitializer = ->
  Factlink.commonInitializer()
  Factlink.notificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new NonConfirmedEmailWarning
  new FactlinkRouter
  enhanceSearchFormNavigation()
  refreshOnSocialSignin()

enhanceSearchFormNavigation = ->
  $('.js-navbar-search-form').on 'submit', ->
    url = '/search?s=' + encodeURIComponent $('.js-navbar-search-box').val()
    Backbone.history.navigate url, true
    false

refreshOnSocialSignin = ->
  currentSession.on 'user_refreshed', ->
    # We still have some static user-dependent stuff on the site (not client)
    window.location.reload(true)
