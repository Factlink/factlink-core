showComponent = (component)->
  el = document.querySelector('#main-column')
  React.renderComponent(component, el)

class FactlinkRouter extends Backbone.Router
  routes:
    'feed': ->
      showComponent ReactFeedSelection()
      mp_track 'Viewed feed'

    'search': 'search' # must be named

    'user/:username/edit': ->
      showComponent ReactProfileEdit model: currentSession.user()

    'user/:username/notification-settings': ->
      showComponent ReactNotificationSettings model: currentSession.user()

    'user/:username/change-password': ->
      showComponent ReactChangePassword model: currentSession.user().password()

    'user/:username': (username) ->
      user = new User(username: username)
      user.fetch()

      showComponent ReactProfile model: user
    'd/:fact_id': (fact_id) ->
      if !window.is_kennisland
        alert('This is not supported in factlink mode!')

      Factlink.load_client_dependencies()

      fact = new Fact id: fact_id
      fact.fetch()

      showComponent ReactDiscussionStandalone
        model: fact
        initiallyFocusAddComment: true
        key: fact_id
        site_url: ('f/' + fact_id)
  search: (params={}) ->
    @once 'route', (route) ->
      return if route == 'search'

      Factlink.topbarSearchModel.clear()

    query = params['s']
    Factlink.topbarSearchModel.set {query}

    results = new SearchResults [], search: query
    results.fetch()

    showComponent ReactSearchResults model: results

    mp_track 'Search: Top bar search',
      query: query


Factlink.siteInitializer = ->
  Factlink.commonInitializer()
  Factlink.topbarSearchModel = new Backbone.Model
  Factlink.notificationCenter = new NotificationCenter('.js-notification-center-alerts')
  new NonConfirmedEmailWarning
  new FactlinkRouter
  renderTopbar()

renderTopbar = ->
  React.renderComponent ReactTopbar(), document.querySelector('#js-topbar-region')
