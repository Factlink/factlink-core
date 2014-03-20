class window.ProfileRouter extends Backbone.Router
  routes:
    ':username': 'showProfile'
    ':username/notification-settings': 'showNotificationSettings'

  # ACTIONS
  showProfile: (username) ->
    @showPage username, @profile_options()

  showNotificationSettings: (username) ->
    @showPage username, @notification_options(username)

  # HELPERS
  profile_options: ->
    active_tab: 'show'
    render: (main_region, user) =>
      if user.get('deleted')
        main_region.show new TextView text: 'This profile has been deleted.'
      else
        main_region.show new ReactView component:
          ReactProfile model: user

  notification_options: (username)->
    active_tab: 'notification-settings'
    render: (main_region, user) ->
      main_region.show new ReactView
        component: ReactNotificationSettings
          model: user

  showPage: (username, options) ->
    @main = new TabbedMainRegionLayout();
    FactlinkApp.mainRegion.show(@main)
    @getUser username,
      onFetch: (user) =>
        @main.tabsRegion.show(@getUserTabs(user, options.active_tab))
        options.render(@main.contentRegion, user)

  switchToPage: (username, user, path, options)->
    @main.tabsRegion.currentView.activate(options.active_tab)
    options.render(@main.contentRegion, user)
    Backbone.history.navigate path, false

  getUserTabs: (user, active_tab) ->
    usertabs = new UserTabsView(model: user, active_tab: active_tab)
    username = user.get('username')
    userjson = user.toJSON()
    usertabs.on 'showProfile',       => @switchToPage(username, user, userjson.link , @profile_options())
    usertabs.on 'showNotifications', => @switchToPage(username, user,userjson.notifications_settings_path, @notification_options(username))

  getUser: (username, options) ->
    user = new User(username: username)
    user.fetch
      success: -> options.onFetch(user)
