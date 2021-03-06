showComponent = (component)->
  el = document.querySelector('#main-column')
  React.renderComponent(component, el)

class FactlinkRouter extends Backbone.Router
  routes:
    'feed': ->
      showComponent ReactFeedSelection()

    'search': 'search' # must be named

    'user/:username/edit': ->
      showComponent ReactProfileEdit model: currentSession.user()

    'user/:username/groups': ->
      showComponent ReactGroupMembershipEdit user: currentSession.user()

    'user/:username/notification-settings': ->
      showComponent ReactNotificationSettings model: currentSession.user()

    'user/:username/change-password': ->
      showComponent ReactChangePassword model: currentSession.user().password()

    'user/:username': (username) ->
      user = new User(username: username)
      user.fetch()

      showComponent ReactProfile model: user

  search: (params={}) ->
    @once 'route', (route) ->
      return if route == 'search'

      Factlink.topbarSearchModel.clear()

    query = params['s']
    Factlink.topbarSearchModel.set {query}

    results = new SearchResults [], search: query
    results.fetch()

    showComponent ReactSearchResults model: results

Factlink.siteInitializer = ->
  Factlink.commonInitializer()
  Factlink.topbarSearchModel = new Backbone.Model
  Factlink.notificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new NonConfirmedEmailWarning
  new FactlinkRouter
  renderTopbar()

renderTopbar = ->
  React.renderComponent ReactTopbar(), document.querySelector('#js-topbar-region')
