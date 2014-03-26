showComponent = (component)->
  el = document.querySelector('#main-wrapper')
  React.renderComponent(component, el)

class FactlinkRouter extends Backbone.Router
  routes:
    'feed': ->
      showComponent ReactFeedSelection()
      mp_track 'Viewed feed'

    'search': (params={}) ->
      Backbone.history.once 'route', (router, executed_route_name) ->
        return if executed_route_name == 'showSearch'

        $('.js-navbar-search-box').val('')

      query = params['s']
      $('.js-navbar-search-box').val(query)
      results = new SearchResults [], search: query

      showComponent ReactSearchResults model: results

      results.fetch()
      mp_track 'Search: Top bar search',
        query: query

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


window.FactlinkAppMode ?= {}
window.FactlinkAppMode.coreInSite = (app) ->
  Factlink.notificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new NonConfirmedEmailWarning
  new FactlinkRouter
  enhanceSearchFormNavigation()

enhanceSearchFormNavigation = ->
  $('.js-navbar-search-form').on 'submit', ->
    url = '/search?s=' + encodeURIComponent $('.js-navbar-search-box').val()
    Backbone.history.navigate url, true
    false
